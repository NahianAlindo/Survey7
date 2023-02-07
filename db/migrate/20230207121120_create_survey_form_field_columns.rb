class CreateSurveyFormFieldColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_form_field_columns do |t|
      t.text :title, limit: 4294967295
      t.text :hint, limit: 4294967295
      t.string :code
      t.boolean :required, default: false
      t.boolean :active, default: true
      t.integer :input_type, default: 0
      t.boolean :removable, default: true
      t.integer :ordering
      t.string :header_name
      t.boolean :all_logic, default: false
      t.boolean :all_validation, default: false
      t.string :error_message
      t.text :title_bn
      t.text :hint_bn
      t.string :error_message_bn
      t.references :survey_form_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
