class Survey < ApplicationRecord
  belongs_to :survey_token, optional: true
  belongs_to :survey_project
  has_many :survey_forms, dependent: :destroy
  has_many :survey_users, dependent: :destroy
  has_many :survey_responses, dependent: :destroy

  validates :title, presence: true, length: { maximum: 250 }
  validates :code, length: { maximum: 250 }
  validates :survey_token_id, presence: true, if: :private?

  def private?
    self.survey_project.private
  end

  def published_form
    survey_forms&.Published&.last
  end

  def formatted_title
    "#{code} | #{title}"
  end
end
