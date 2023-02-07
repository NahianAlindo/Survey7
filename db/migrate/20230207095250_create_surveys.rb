class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.string :title
      t.string :code
      t.boolean :active, default: true
      t.boolean :has_listing_book, default:false
      t.json :main_sheet_info
      t.json :review_sheet_info
      t.json :matrix_field_data_user
      t.json :matrix_field_data_reviewer
      t.string :title_bn
      t.references :survey_token, null: false, foreign_key: true
      t.references :survey_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
