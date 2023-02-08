class SurveyToken < ApplicationRecord
  has_many :survey_projects
  has_many :survey_project_users
  has_many :surveys
  has_many :survey_users

  validates :token, presence: true, uniqueness: true, length: { maximum: 250 }
  validates :start_date, :end_date, presence: true

  validate :check_time

  def check_time
    errors.add :start_date, "should be greater than end date" if start_date && end_date && start_date > end_date
  end

  INDIVIDUAL_SURVEY = 0
  SURVEY_PROJECT = 1

  enum token_type: {
    Individual_Survey: INDIVIDUAL_SURVEY,
    Survey_Project: SURVEY_PROJECT
  }

  def formatted_name
    "Token #{token} | validity: #{start_date} to #{end_date}"
  end
end
