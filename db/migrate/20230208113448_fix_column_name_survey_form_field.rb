class FixColumnNameSurveyFormField < ActiveRecord::Migration[7.0]
  def change
    rename_column :survey_form_fields, :size_after_compression, :size_limit_after_compression
  end
end
