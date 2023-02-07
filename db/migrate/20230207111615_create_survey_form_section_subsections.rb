class CreateSurveyFormSectionSubsections < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_form_section_subsections do |t|
      t.string :title
      t.string :code
      t.integer :ordering
      t.boolean :removable, default: true
      t.boolean :active, default: true
      t.boolean :all_logic, default: false
      t.string :title_bn
      t.references :survey_form, null: false, foreign_key: true
      t.references :survey_form_section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
