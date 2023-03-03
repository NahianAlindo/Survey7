# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_08_113448) do
  create_table "survey_dependent_fields", force: :cascade do |t|
    t.integer "condition_type", default: 0
    t.string "value"
    t.integer "survey_form_field_id", null: false
    t.integer "survey_form_field_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_form_section_id"
    t.integer "survey_form_field_column_id"
    t.integer "survey_form_section_subsection_id"
    t.index ["survey_form_field_column_id"], name: "index_survey_dependent_fields_on_survey_form_field_column_id"
    t.index ["survey_form_field_id"], name: "index_survey_dependent_fields_on_survey_form_field_id"
    t.index ["survey_form_field_option_id"], name: "index_survey_dependent_fields_on_survey_form_field_option_id"
    t.index ["survey_form_section_id"], name: "section_to_dependent_field_index"
    t.index ["survey_form_section_subsection_id"], name: "sub_section_to_dependent_field_index"
  end

  create_table "survey_form_field_columns", force: :cascade do |t|
    t.text "title", limit: 4294967295
    t.text "hint", limit: 4294967295
    t.string "code"
    t.boolean "required", default: false
    t.boolean "active", default: true
    t.integer "input_type", default: 0
    t.boolean "removable", default: true
    t.integer "ordering"
    t.string "header_name"
    t.boolean "all_logic", default: false
    t.boolean "all_validation", default: false
    t.string "error_message"
    t.text "title_bn"
    t.text "hint_bn"
    t.string "error_message_bn"
    t.integer "survey_form_field_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_form_field_id"], name: "index_survey_form_field_columns_on_survey_form_field_id"
  end

  create_table "survey_form_field_options", force: :cascade do |t|
    t.integer "value", default: 0
    t.text "label", limit: 4294967295
    t.boolean "custom_input", default: false
    t.string "name"
    t.text "label_bn"
    t.integer "survey_form_field_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_form_field_column_id"
    t.index ["survey_form_field_column_id"], name: "index_survey_form_field_options_on_survey_form_field_column_id"
    t.index ["survey_form_field_id"], name: "index_survey_form_field_options_on_survey_form_field_id"
  end

  create_table "survey_form_fields", force: :cascade do |t|
    t.string "name"
    t.text "show_as", limit: 4294967295
    t.text "hint", limit: 4294967295
    t.integer "input_type", default: 0
    t.boolean "required", default: false
    t.boolean "active", default: true
    t.boolean "removable", default: true
    t.integer "ordering", default: 1
    t.string "header_name"
    t.boolean "all_logic", default: false
    t.boolean "all_validation", default: false
    t.string "error_message"
    t.integer "max_matrix_row", default: 10
    t.text "show_as_bn"
    t.text "hint_bn"
    t.decimal "size_limit", precision: 40, scale: 10
    t.decimal "size_limit_after_compression", precision: 10
    t.string "error_message_bn"
    t.integer "survey_form_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_form_section_subsection_id"
    t.integer "survey_form_section_id"
    t.index ["survey_form_id"], name: "index_survey_form_fields_on_survey_form_id"
    t.index ["survey_form_section_id"], name: "index_survey_form_fields_on_survey_form_section_id"
    t.index ["survey_form_section_subsection_id"], name: "index_survey_form_fields_on_survey_form_section_subsection_id"
  end

  create_table "survey_form_section_subsections", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.integer "ordering"
    t.boolean "removable", default: true
    t.boolean "active", default: true
    t.boolean "all_logic", default: false
    t.string "title_bn"
    t.integer "survey_form_id", null: false
    t.integer "survey_form_section_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_form_id"], name: "index_survey_form_section_subsections_on_survey_form_id"
    t.index ["survey_form_section_id"], name: "index_survey_form_section_subsections_on_survey_form_section_id"
  end

  create_table "survey_form_sections", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.integer "ordering"
    t.boolean "removable", default: true
    t.boolean "active", default: true
    t.integer "section_type", default: 0
    t.boolean "all_logic"
    t.string "title_bn"
    t.integer "survey_form_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_form_id"], name: "index_survey_form_sections_on_survey_form_id"
  end

  create_table "survey_forms", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.float "version", default: 0.0
    t.integer "status", default: 0
    t.json "mobile_json_form"
    t.integer "file_upload_status", default: 0
    t.integer "survey_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_id"
    t.index ["survey_id"], name: "index_survey_forms_on_survey_id"
    t.index ["survey_project_id"], name: "index_survey_forms_on_survey_project_id"
  end

  create_table "survey_project_users", force: :cascade do |t|
    t.boolean "active", default: true
    t.integer "survey_token_id", null: false
    t.integer "survey_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_project_id"], name: "index_survey_project_users_on_survey_project_id"
    t.index ["survey_token_id"], name: "index_survey_project_users_on_survey_token_id"
  end

  create_table "survey_projects", force: :cascade do |t|
    t.boolean "active"
    t.boolean "private"
    t.string "title"
    t.string "code"
    t.string "title_bn"
    t.integer "survey_token_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_token_id"], name: "index_survey_projects_on_survey_token_id"
  end

  create_table "survey_responses", force: :cascade do |t|
    t.string "title"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer "status", default: 0
    t.json "dynamic_fields"
    t.integer "file_upload_status", default: 0
    t.json "main_sheet_data"
    t.json "reviewer_sheet_data"
    t.json "matrix_data_user_section"
    t.json "matrix_data_reviewer_section"
    t.integer "platform", default: 0
    t.integer "form_job_status", default: 0
    t.json "time_locations"
    t.integer "survey_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "survey_form_id"
    t.integer "survey_id"
    t.index ["survey_form_id"], name: "index_survey_responses_on_survey_form_id"
    t.index ["survey_id"], name: "index_survey_responses_on_survey_id"
    t.index ["survey_project_id"], name: "index_survey_responses_on_survey_project_id"
  end

  create_table "survey_tokens", force: :cascade do |t|
    t.string "token"
    t.date "start_date"
    t.date "end_date"
    t.boolean "active", default: true
    t.integer "token_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "survey_users", force: :cascade do |t|
    t.boolean "active", default: true
    t.integer "survey_token_id", null: false
    t.integer "survey_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_users_on_survey_id"
    t.index ["survey_token_id"], name: "index_survey_users_on_survey_token_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.boolean "active", default: true
    t.boolean "has_listing_book", default: false
    t.json "main_sheet_info"
    t.json "review_sheet_info"
    t.json "matrix_field_data_user"
    t.json "matrix_field_data_reviewer"
    t.string "title_bn"
    t.integer "survey_token_id", null: false
    t.integer "survey_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_project_id"], name: "index_surveys_on_survey_project_id"
    t.index ["survey_token_id"], name: "index_surveys_on_survey_token_id"
  end

  add_foreign_key "survey_dependent_fields", "survey_form_field_options"
  add_foreign_key "survey_dependent_fields", "survey_form_fields"
  add_foreign_key "survey_form_field_columns", "survey_form_fields"
  add_foreign_key "survey_form_field_options", "survey_form_fields"
  add_foreign_key "survey_form_fields", "survey_forms"
  add_foreign_key "survey_form_section_subsections", "survey_form_sections"
  add_foreign_key "survey_form_section_subsections", "survey_forms"
  add_foreign_key "survey_form_sections", "survey_forms"
  add_foreign_key "survey_forms", "survey_projects"
  add_foreign_key "survey_project_users", "survey_projects"
  add_foreign_key "survey_project_users", "survey_tokens"
  add_foreign_key "survey_projects", "survey_tokens"
  add_foreign_key "survey_responses", "survey_projects"
  add_foreign_key "survey_users", "survey_tokens"
  add_foreign_key "survey_users", "surveys"
  add_foreign_key "surveys", "survey_projects"
  add_foreign_key "surveys", "survey_tokens"
end
