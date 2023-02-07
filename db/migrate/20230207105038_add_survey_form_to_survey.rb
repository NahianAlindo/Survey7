class AddSurveyFormToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_reference :survey_forms, :survey, index: true
  end
end
