class CreateSurveyDependentFields < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_dependent_fields do |t|
      t.integer :condition_type, default: 0
      t.string :value
      t.references :survey_form_field, null: false, foreign_key: true
      t.references :survey_form_field_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
