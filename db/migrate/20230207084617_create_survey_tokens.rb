class CreateSurveyTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_tokens do |t|
      t.string :token
      t.date :start_date
      t.date :end_date
      t.boolean :active, default: true
      t.integer :token_type, default: 0

      t.timestamps
    end
  end
end
