class AddSurveyFormFieldOptionToSurveyFormFieldColumn < ActiveRecord::Migration[7.0]
  def change
    add_reference :survey_form_field_options, :survey_form_field_column, index: true
  end
end
