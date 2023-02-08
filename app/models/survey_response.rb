class SurveyResponse < ApplicationRecord
  belongs_to :survey_project

  include TranslateEnum

  has_one_attached :json_form_file
  has_one_attached :json_form_file_bn

  has_many :form_attachments, as: :target, dependent: :destroy
  alias_attribute :attachment_infos, :form_attachments

  # belongs_to :creator, class_name: 'User', foreign_key: :creator_id, optional: true
  # belongs_to :approver, class_name: 'User', foreign_key: :approver_id, optional: true
  # belongs_to :current_reviewer, class_name: 'User', foreign_key: :current_reviewer_id, optional: true
  belongs_to :survey
  belongs_to :survey_form
  belongs_to :survey_project
  belongs_to :listing_book_entry, optional: true

  validates :title, presence: true, length: { maximum: 250 }, uniqueness: { scope: :survey_id }

  after_commit :store_json_review_form

  FILE_UPLOAD_STATUS = {
    not_started: 0,
    started: 1,
    completed: 2,
    failed: 3
  }.freeze

  FORM_JOB_STATUS = {
    default: 0,
    enqueued: 1,
    performing: 2,
    performed: 3
  }.freeze

  DRAFTED = 0
  SUBMITTED = 1
  APPROVED = 2
  REJECTED = 3
  IN_REVIEW = 4

  enum status: {
    Drafted: DRAFTED,
    Submitted: SUBMITTED,
    Approved: APPROVED,
    Rejected: REJECTED,
    In_review: IN_REVIEW
  }

  enum platform: {
    Web: 0,
    Mobile_App: 1
  }

  translate_enum :status

  def approve_or_reject(sts, current_user)
    ActiveRecord::Base.transaction do
      if Submitted?
        if sts == SurveyResponse.statuses.key(SurveyResponse::APPROVED)
          self.status = sts
          self.approver = current_user
          save!
        elsif sts == SurveyResponse.statuses.key(SurveyResponse::REJECTED)
          self.status = sts
          self.approver = current_user
          save!
        end
      else
        false
      end
    end
    build_export_data if Approved?
    true
  end

  def build_export_data
    # TODO: This should process in background later
    BuildSurveyResponseExportDataJob.perform_now(self)
  end

  def set_status(sts, current_user)
    ActiveRecord::Base.transaction do
      if Approved?
        false
      elsif sts == SurveyResponse.statuses.key(SurveyResponse::IN_REVIEW)
        self.status = sts
        self.end_datetime = Time.now.utc
        save!
      elsif sts == SurveyResponse.statuses.key(SurveyResponse::SUBMITTED)
        self.status = sts
        self.end_datetime = Time.now.utc unless end_datetime.present?
        save!
      end
    end
    true
  end

  def review_needed?
    survey_form.review_needed?
  end

  def under_review_of_another_user?(current_user)
    current_reviewer_id.present? && current_reviewer_id != current_user.id
  end

  def withdraw_user_review(current_user)
    reviewer_sections = dynamic_fields['reviewer_sections']
    if reviewer_sections.present?
      reviewer_sections = reviewer_sections.except(current_user.email)
      dynamic_fields['reviewer_sections'] = reviewer_sections
    end
  end

  def existing_reviewers
    begin
      dynamic_fields['reviewer_sections'].keys
    rescue
      []
    end
  end

  def store_json_review_form
    if (status == 'In_review') &&
      (saved_change_to_status? || saved_change_to_dynamic_fields?) &&
      self.form_job_status != FORM_JOB_STATUS[:enqueued]

      GenerateMobileSurveyResponseFormJob.perform_later(id)
    end
  end

  def psu_no
    begin
      listing_book_entry.listing_book.psu_no.to_s
    rescue
      ''
    end
  end

  after_create :update_form_attachments

  def update_form_attachments
    ids = SurveyResponseManager::AttachFormAttachments.call(self)
    FormAttachment.where(id: ids).each do |form_attachment|
      form_attachment.target = self
      form_attachment.save
    end
  end
end
