class SurveyProject < ApplicationRecord
  belongs_to :survey_token, optional: true
  has_many :survey_forms
  has_many :survey_responses
  has_many :surveys, dependent: :destroy
  has_many :survey_project_users, dependent: :destroy

  validates :title, presence: true, length: { maximum: 250 }
  validates :code, length: { maximum: 250 }

  scope :public_projects, -> { where(private: false) }
  scope :private_projects, -> { where(private: true) }

  after_create :set_code

  def set_code
    self.code = "SPROJ-#{id}"
    save!
  end

  def formatted_title
    "#{code} | #{self.title}"
  end
end
