class CreateSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_responses do |t|
      t.string :title
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer :status, default: 0
      t.json :dynamic_fields
      t.integer :file_upload_status, default: 0
      t.json :main_sheet_data
      t.json :reviewer_sheet_data
      t.json :matrix_data_user_section
      t.json :matrix_data_reviewer_section
      t.integer :platform, default: 0
      t.integer :form_job_status, default: 0
      t.json :time_locations
      t.references :survey_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
