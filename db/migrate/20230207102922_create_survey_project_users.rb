class CreateSurveyProjectUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_project_users do |t|
      t.boolean :active, default: true
      t.references :survey_token, null: false, foreign_key: true
      t.references :survey_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
