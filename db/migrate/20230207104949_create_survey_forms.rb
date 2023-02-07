class CreateSurveyForms < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_forms do |t|
      t.string :title
      t.string :code
      t.float :version, default: 0.0
      t.integer :status, default: 0
      t.json :mobile_json_form
      t.integer :file_upload_status, default: 0
      t.references :survey_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
