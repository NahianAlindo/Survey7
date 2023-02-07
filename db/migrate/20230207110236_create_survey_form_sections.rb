class CreateSurveyFormSections < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_form_sections do |t|
      t.string :title
      t.string :code
      t.integer :ordering
      t.boolean :removable, default: true
      t.boolean :active, default: true
      t.integer :section_type, default: 0
      t.boolean :all_logic, boolean: false
      t.string :title_bn
      t.references :survey_form, null: false, foreign_key: true

      t.timestamps
    end
  end
end
