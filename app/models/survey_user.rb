class SurveyUser < ApplicationRecord
  belongs_to :survey_token
  belongs_to :survey
end
