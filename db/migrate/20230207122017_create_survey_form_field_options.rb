class CreateSurveyFormFieldOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_form_field_options do |t|
      t.integer :value, default: 0
      t.text :label, limit: 4294967295
      t.boolean :custom_input, default: false
      t.string :name
      t.text :label_bn
      t.references :survey_form_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
