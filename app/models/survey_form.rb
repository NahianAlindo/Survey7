class SurveyForm < ApplicationRecord
  belongs_to :survey_project
  belongs_to :survey
  has_many :survey_form_fields, dependent: :destroy
  has_many :survey_form_sections, dependent: :destroy
  has_many :survey_form_section_subsections

  has_one_attached :json_form_file
  has_one_attached :json_form_file_bn

  validates :title, length: { maximum: 250 }
  validates :code, length: { maximum: 250 }

  accepts_nested_attributes_for :survey_form_fields,
                                allow_destroy: true,
                                reject_if: proc { |att| att['show_as'].blank? }

  accepts_nested_attributes_for :survey_form_sections,
                                allow_destroy: true,
                                reject_if: proc { |att| att['title'].blank? }

  alias_attribute :children, :survey_form_fields
  alias_attribute :sections, :survey_form_sections
  alias_attribute :subsections, :survey_form_section_subsections

  def presence_of_survey_fields
    errors.add :survey_form_fields, 'should not be zero' if survey_form_fields.length.eql?(0)
  end

  amoeba do
    enable
    include_association :survey_form_fields
    include_association :survey_form_sections
  end

  DRAFTED = 0
  PUBLISHED = 1
  ARCHIVED = 2

  enum status: {
    Drafted: DRAFTED,
    Published: PUBLISHED,
    Archived: ARCHIVED
  }

  FILE_UPLOAD_STATUS = {
    not_started: 0,
    started: 1,
    completed: 2,
    failed: 3
  }.freeze

  def admin_area_input_count
    survey_form_fields.admin_areas_4_types.count + survey_form_fields.admin_areas_5_types.count
  end

  def reorderable?
    Drafted?
  end

  def publish
    result = false

    ActiveRecord::Base.transaction do
      self.status = SurveyForm.statuses.key(SurveyForm::PUBLISHED)
      if save
        survey_form_fields.each do |survey_form_field|
          return false unless survey_form_field.lock
        end

        sections.each do |section|
          return false unless section.lock

          section.subsections.each do |subsection|
            return false unless subsection.lock
          end
        end

        survey.survey_forms.Published.where.not(id: id).each(&:Archived!)
        result = true
      else
        result = false
      end
    end

    if result.present?
      upload_form_files_to_storages
      build_survey_export_data
    end

    result
  end

  def upload_form_files_to_storages
    GenerateMobileSurveyFormJob.perform_later(self)

    survey.survey_responses.In_review.pluck(:id).each do |survey_response_id|
      GenerateMobileSurveyResponseFormJob.perform_later(survey_response_id)
    end
  end

  def build_survey_export_data
    # TODO: This should process in background later
    BuildSurveyExportDataJob.perform_now(survey)
  end

  def self.update_mobile_form_data
    SurveyForm.Published.where(mobile_json_form: nil).find_each(batch_size: 1) do |form|
      puts "=== Building mobile json form for form with id: #{form.try(:id)} ==="
      mobile_survey_form = MobileFormBuilder::GenerateSurveyFormData.call(form)
      form.update(mobile_json_form: mobile_survey_form)
    end
  end

  def get_skip_logics
    skip_logics = {
      parent: {},
      column_parent: {},
      dependent: []
    }
    survey_form_fields.each do |survey_form_field|
      logics = survey_form_field.get_skip_logics
      skip_logics = prepare_skip_logic(skip_logics, logics)

      next unless survey_form_field.input_type.eql?(SurveyFormField.input_types.key(SurveyFormField::MATRIX))

      survey_form_field.columns&.each do |column|
        logics = SurveyFormFieldColumn.includes([:survey_dependent_fields]).find(column.id).get_skip_logics
        skip_logics = prepare_skip_logic(skip_logics, logics, :column_parent, column.field&.id)
      end
    end

    sections.each do |section|
      logics = section.get_skip_logics
      skip_logics = prepare_skip_logic(skip_logics, logics)

      section.subsections.each do |subsection|
        logics = subsection.get_skip_logics
        skip_logics = prepare_skip_logic(skip_logics, logics)
      end
    end

    skip_logics
  end

  def prepare_skip_logic(skip_logics, logics, parent_type=:parent, parent_field=nil)
    unless logics.empty?
      logics.each do |logic|
        parent_id = if parent_field.present?
                      "#{parent_field}_#{logic[:dependent_option_parent]}"
                    else
                      logic[:dependent_option_parent]
                    end
        if skip_logics[parent_type][parent_id].present?
          skip_logics[parent_type][parent_id] << logic
        else
          skip_logics[parent_type][parent_id] = [logic]
        end
      end
      skip_logics[:dependent] << { logics: logics } unless logics.empty?
    end

    skip_logics
  end

  def generate_new_names
    sections&.each do |section|
      section.fields&.each do |field|
        field.set_name
        field.generate_option_names
        field.generate_column_option_names
        field.save!
      end

      section.subsections&.each do |subsection|
        subsection.fields&.each do |field|
          field.set_name
          field.generate_option_names
          field.generate_column_option_names
          field.save!
        end
      end
    end

    if self.version < 0
      self.version = 1
      self.save!
    end
  end

  def in_process?
    version < 0
  end

  after_update :update_ordering

  def update_ordering
    field_ordering = 1
    sections&.each_with_index do |section, section_idx|
      section.fields&.each do |section_field|
        section_field.update!(ordering: field_ordering)
        field_ordering += 1

        column_ordering = 1
        section_field.columns&.each do |column|
          column.update!(ordering: column_ordering)
          column_ordering += 1
        end
      end

      section.update!(ordering: section_idx + 1)

      section.subsections&.each_with_index do |subsection, subsection_idx|
        subsection.fields&.each do |subsection_field|
          subsection_field.update!(ordering: field_ordering)
          field_ordering += 1

          column_ordering = 1
          subsection_field.columns&.each do |column|
            column.update!(ordering: column_ordering)
            column_ordering += 1
          end
        end

        subsection.update!(ordering: subsection_idx + 1)
      end
    end
  end

  def review_needed?
    sections.for_reviewers.count.positive?
  end

  def get_json_data
    data = {}
    data[:sections] = []

    sections&.each do |section|
      data[:sections] << section.get_json_data
    end

    data
  end
end
