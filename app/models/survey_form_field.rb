class SurveyFormField < ApplicationRecord
  belongs_to :survey_form
  belongs_to :survey_form_section, optional: true
  belongs_to :survey_form_section_subsection, optional: true
  has_many :survey_form_field_options, dependent: :destroy
  has_many :survey_form_field_columns, dependent: :destroy
  has_many :survey_dependent_fields, dependent: :destroy

  validates :name, length: { maximum: 250 }
  validates :show_as, length: { maximum: 4_294_967_294 }
  validates :hint, length: { maximum: 4_294_967_294 }
  validates :header_name, length: { maximum: 250 }
  validates :error_message, length: { maximum: 250 }

  accepts_nested_attributes_for :survey_form_field_options,
                                allow_destroy: true,
                                reject_if: proc { |att| att['label'].blank? }

  accepts_nested_attributes_for :survey_form_field_columns,
                                allow_destroy: true,
                                reject_if: proc { |att| att['title'].blank? }

  amoeba do
    enable
    include_association :survey_form_field_options
    include_association :survey_form_field_columns
  end

  alias_attribute :parent, :survey_form
  alias_attribute :subsection, :survey_form_section_subsection
  alias_attribute :section, :survey_form_section
  alias_attribute :options, :survey_form_field_options
  alias_attribute :columns, :survey_form_field_columns
  alias_attribute :validations, :survey_form_field_validations

  INPUT_SHORT_TEXT          = 0
  INPUT_LONG_TEXT           = 1
  INPUT_SELECT_ONE_DROPDOWN = 2
  INPUT_SELECT_ONE_RADIO    = 10
  INPUT_SELECT_MANY         = 3
  INPUT_NUMBER              = 4
  INPUT_NON_NEGATIVE_NUMBER = 12
  INPUT_DECIMAL_NUMBER      = 13
  INPUT_DATE                = 5
  INPUT_TIME                = 6
  INPUT_ACKNOWLEDGE         = 7
  ADMIN_AREAS_4_TYPES       = 8
  ADMIN_AREAS_5_TYPES       = 11
  MATRIX                    = 9
  IMAGE                     = 14
  VIDEO                     = 15
  ATTACHMENT                = 16

  enum input_type: {
    short_text: INPUT_SHORT_TEXT,
    long_text: INPUT_LONG_TEXT,
    select_one_dropdown: INPUT_SELECT_ONE_DROPDOWN,
    select_one_radio: INPUT_SELECT_ONE_RADIO,
    select_many: INPUT_SELECT_MANY,
    non_negative_number: INPUT_NON_NEGATIVE_NUMBER,
    number: INPUT_NUMBER,
    decimal_number: INPUT_DECIMAL_NUMBER,
    date: INPUT_DATE,
    time: INPUT_TIME,
    acknowledge: INPUT_ACKNOWLEDGE,
    admin_areas_4_types: ADMIN_AREAS_4_TYPES,
    admin_areas_5_types: ADMIN_AREAS_5_TYPES,
    matrix: MATRIX,
    image: IMAGE,
    video: VIDEO,
    attachment: ATTACHMENT
  }

  SINGLE_VALUE_TYPES = [
    SurveyFormField.input_types.key(INPUT_SHORT_TEXT),
    SurveyFormField.input_types.key(INPUT_LONG_TEXT),
    SurveyFormField.input_types.key(INPUT_NUMBER),
    SurveyFormField.input_types.key(INPUT_DATE),
    SurveyFormField.input_types.key(INPUT_TIME),
    SurveyFormField.input_types.key(INPUT_ACKNOWLEDGE),
    SurveyFormField.input_types.key(INPUT_DECIMAL_NUMBER),
    SurveyFormField.input_types.key(INPUT_NON_NEGATIVE_NUMBER)
  ].freeze

  SINGLE_CHOICE_VALUES_TYPES = [
    SurveyFormField.input_types.key(INPUT_SELECT_ONE_DROPDOWN),
    SurveyFormField.input_types.key(INPUT_SELECT_ONE_RADIO)
  ].freeze

  MULTI_CHOICE_VALUES_TYPES = [
    SurveyFormField.input_types.key(INPUT_SELECT_MANY)
  ].freeze

  MULTIMEDIA_VALUES_TYPES = [
    SurveyFormField.input_types.key(IMAGE),
    SurveyFormField.input_types.key(VIDEO),
    SurveyFormField.input_types.key(ATTACHMENT)
  ].freeze

  ADMIN_AREA_VALUES_TYPES = [
    SurveyFormField.input_types.key(ADMIN_AREAS_4_TYPES),
    SurveyFormField.input_types.key(ADMIN_AREAS_5_TYPES)
  ].freeze


  default_scope { order(:ordering) }
  scope :has_options, lambda {
    where(input_type: [INPUT_SELECT_ONE_RADIO,
                       INPUT_SELECT_ONE_DROPDOWN,
                       INPUT_SELECT_MANY])
  }

  def has_custom_input?
    selection_input? and options.pluck(:custom_input).include?(true)
  end

  def selection_input?
    [SurveyFormField.input_types.key(INPUT_SELECT_ONE_RADIO),
     SurveyFormField.input_types.key(INPUT_SELECT_ONE_DROPDOWN),
     SurveyFormField.input_types.key(INPUT_SELECT_MANY)].include? input_type
  end

  def text_input?
    [SurveyFormField.input_types.key(INPUT_SHORT_TEXT),
     SurveyFormField.input_types.key(INPUT_LONG_TEXT)].include? input_type
  end

  def number_input?
    [SurveyFormField.input_types.key(INPUT_NUMBER),
     SurveyFormField.input_types.key(INPUT_NON_NEGATIVE_NUMBER),
     SurveyFormField.input_types.key(INPUT_DECIMAL_NUMBER)].include? input_type
  end

  def date_input?
    [SurveyFormField.input_types.key(INPUT_DATE)].include? input_type
  end

  def time_input?
    [SurveyFormField.input_types.key(INPUT_TIME)].include? input_type
  end

  def multimedia_input?
    [SurveyFormField.input_types.key(IMAGE),
     SurveyFormField.input_types.key(VIDEO),
     SurveyFormField.input_types.key(ATTACHMENT)].include? input_type
  end

  def validatable?
    text_input? || number_input? || date_input?
  end

  def lock
    self.removable = false

    if matrix?
      columns&.each do |column|
        return false unless column.lock
      end
    end

    save ? true : false
  end

  def section_field?
    survey_form_section.present?
  end

  def subsection_field?
    survey_form_section_subsection.present?
  end

  def truncated_show_as
    pre = ''
    if section_field?
      pre = "- #{survey_form_section.get_local_value('title')}"
    elsif subsection_field?
      pre = "-- #{survey_form_section_subsection.get_local_value('title')}"
    end

    ActionView::Base.full_sanitizer
                    .sanitize(pre)&.truncate(40, omission: "...#{pre.last(10)}")&.to_s + " | " +
      ActionView::Base.full_sanitizer
                      .sanitize(self.get_local_value('show_as'))&.truncate(150, omission: "...#{self.get_local_value('show_as')&.last(10)}")&.to_s
  end

  def truncated_show_as_local
    pre = ''
    if section_field?
      pre = "- #{survey_form_section.get_local_value('title')}"
    elsif subsection_field?
      pre = "-- #{survey_form_section_subsection.get_local_value('title')}"
    end

    ActionView::Base.full_sanitizer
                    .sanitize(pre)&.truncate(40, omission: "...#{pre.last(10)}")&.to_s + " | " +
      ActionView::Base.full_sanitizer
                      .sanitize(self.get_local_value('show_as'))&.truncate(150, omission: "...#{self.get_local_value('show_as')&.last(10)}")&.to_s
  end
  def size_limit_before
    return ENV['IMAGE_SIZE_BEFORE'] unless size_limit.present?

    size_limit
  end

  def size_limit_after
    return ENV['IMAGE_SIZE_AFTER'] unless size_limit_after_compression.present?

    size_limit_after_compression
  end

  def get_conditions
    if number_input?
      SurveyDependentField.translated_number_conditions
    else
      SurveyDependentField.translated_string_conditions
    end
  end

  before_create :set_ordering_and_name
  before_create :set_removable

  def set_removable
    self.removable = true
  end

  def set_ordering_and_name
    max_id = SurveyFormField.maximum(:id).to_i + 1
    unless name.present?
      self.name = if select_many?
                    "multiChoice_#{max_id}"
                  else
                    "dynamic_field_#{max_id}"
                  end

      self.ordering = max_id
    end
  end

  def set_name
    self.name = if select_many?
                  "multiChoice_#{id}"
                else
                  "dynamic_field_#{id}"
                end
  end

  def stable_id
    return id unless name.present?

    res = name.scan(/_(\d+)$/).flatten.first rescue nil
    return id unless res.present?

    res.to_i
  end

  def reset_option_names
    return unless options.present?

    options.each do |option|
      option.name = nil
    end
  end

  def generate_option_names
    return unless options.present?

    options.each do |option|
      option.set_name
      option.save!
    end
  end

  def reset_column_option_names
    return unless columns.present?

    columns.each do |column|
      column.code = nil
      column.reset_option_names
    end
  end

  def generate_column_option_names
    return unless columns.present?

    columns.each do |column|
      column.set_name
      column.generate_option_names
      column.save!
    end
  end

  def get_json_data
    data = {}
    data[:base] = self
    data[:options] = []
    data[:columns] = []

    options&.each do |option|
      data[:options] << option.get_json_data
    end

    columns&.each do |column|
      data[:columns] << column.get_json_data
    end

    data
  end
end
