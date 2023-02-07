class SurveyProjectUser < ApplicationRecord
  belongs_to :survey_token
  belongs_to :survey_project
end
