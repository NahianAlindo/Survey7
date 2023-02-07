class AddSurveyFormSectionSubsectionToSurveyFormField < ActiveRecord::Migration[7.0]
  def change
    add_reference  :survey_form_fields,:survey_form_section_subsection, index:true
    add_reference :survey_form_fields,:survey_form_section, index: true
  end
end
