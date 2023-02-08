class AddFieldsToSurveyResponse < ActiveRecord::Migration[7.0]
  def change
    add_reference :survey_responses, :survey_form, index:true
    add_reference :survey_responses, :survey, index:true
  end
end
