class AddFieldsToSurveyDependentFields < ActiveRecord::Migration[7.0]
  def change
    add_reference :survey_dependent_fields, :survey_form_section, index: {name: 'section_to_dependent_field_index'}
    add_reference :survey_dependent_fields, :survey_form_field_column, index: true
    add_reference :survey_dependent_fields, :survey_form_section_subsection, index: {name: 'sub_section_to_dependent_field_index'}
  end
end
