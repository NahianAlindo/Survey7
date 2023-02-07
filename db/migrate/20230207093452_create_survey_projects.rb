class CreateSurveyProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_projects do |t|
      t.boolean :active
      t.boolean :private
      t.string :title
      t.string :code
      t.string :title_bn
      t.references :survey_token, null: false, foreign_key: true

      t.timestamps
    end
  end
end
