class CreateSurveyFormFields < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_form_fields do |t|
      t.string :name
      t.text :show_as, limit: 4294967295
      t.text :hint, limit: 4294967295
      t.integer :input_type, default: 0
      t.boolean :required, default: false
      t.boolean :active, default: true
      t.boolean :removable, default: true
      t.integer :ordering, default: 1
      t.string :header_name
      t.boolean :all_logic, default: false
      t.boolean :all_validation, default: false
      t.string :error_message
      t.integer :max_matrix_row, default: 10
      t.text :show_as_bn
      t.text :hint_bn
      t.decimal :size_limit, precision: 40, scale: 10
      t.decimal :size_after_compression, precision: 10
      t.string :error_message_bn
      t.references :survey_form, null: false, foreign_key: true

      t.timestamps
    end
  end
end
