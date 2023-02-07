class SurveyFormSectionSubsection < ApplicationRecord
  belongs_to :survey_form
  belongs_to :survey_form_section
end
