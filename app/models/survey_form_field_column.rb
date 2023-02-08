class SurveyFormFieldColumn < ApplicationRecord
  belongs_to :survey_form_field, optional: true
  has_many :survey_form_field_options, dependent: :destroy
  has_many :survey_dependent_fields, dependent: :destroy


  accepts_nested_attributes_for :survey_form_field_options,
                                allow_destroy: true,
                                reject_if: proc { |att| att['label'].blank? }

  validates :code, length: { maximum: 250 }
  validates :title, length: { maximum: 4_294_967_294 }
  validates :hint, length: { maximum: 4_294_967_294 }
  validates :header_name, length: { maximum: 250 }

  alias_attribute :options, :survey_form_field_options
  alias_attribute :field, :survey_form_field

  accepts_nested_attributes_for :survey_form_field_options,
                                allow_destroy: true,
                                reject_if: proc { |att| att['label'].blank? }

  validates :code, length: { maximum: 250 }
  validates :title, length: { maximum: 4_294_967_294 }
  validates :hint, length: { maximum: 4_294_967_294 }
  validates :header_name, length: { maximum: 250 }

  alias_attribute :options, :survey_form_field_options
  alias_attribute :field, :survey_form_field
  alias_attribute :validations, :survey_form_field_validations

  amoeba do
    enable
    include_association :survey_form_field_options
  end

  INPUT_SHORT_TEXT            = 0
  INPUT_LONG_TEXT             = 1
  INPUT_SELECT_ONE_DROPDOWN   = 2
  INPUT_SELECT_ONE_RADIO      = 10
  INPUT_SELECT_MANY           = 3
  INPUT_NUMBER                = 4
  INPUT_AUTO_INCREMENT_NUMBER = 8
  INPUT_NON_NEGATIVE_NUMBER   = 11
  INPUT_DECIMAL_NUMBER        = 12
  INPUT_DATE                  = 5
  INPUT_TIME                  = 6
  INPUT_ACKNOWLEDGE           = 7

  enum input_type: {
    short_text: INPUT_SHORT_TEXT,
    long_text: INPUT_LONG_TEXT,
    select_one_dropdown: INPUT_SELECT_ONE_DROPDOWN,
    select_one_radio: INPUT_SELECT_ONE_RADIO,
    select_many: INPUT_SELECT_MANY,
    non_negative_number: INPUT_NON_NEGATIVE_NUMBER,
    number: INPUT_NUMBER,
    decimal_number: INPUT_DECIMAL_NUMBER,
    auto_increment_number: INPUT_AUTO_INCREMENT_NUMBER,
    date: INPUT_DATE,
    time: INPUT_TIME,
    acknowledge: INPUT_ACKNOWLEDGE
  }

  SINGLE_VALUE_TYPES = [
    SurveyFormFieldColumn.input_types.key(INPUT_SHORT_TEXT),
    SurveyFormFieldColumn.input_types.key(INPUT_LONG_TEXT),
    SurveyFormFieldColumn.input_types.key(INPUT_NUMBER),
    SurveyFormFieldColumn.input_types.key(INPUT_DATE),
    SurveyFormFieldColumn.input_types.key(INPUT_TIME),
    SurveyFormFieldColumn.input_types.key(INPUT_ACKNOWLEDGE),
    SurveyFormFieldColumn.input_types.key(INPUT_AUTO_INCREMENT_NUMBER),
    SurveyFormFieldColumn.input_types.key(INPUT_NON_NEGATIVE_NUMBER),
    SurveyFormFieldColumn.input_types.key(INPUT_DECIMAL_NUMBER)
  ]

  SINGLE_CHOICE_VALUES_TYPES = [
    SurveyFormFieldColumn.input_types.key(INPUT_SELECT_ONE_DROPDOWN),
    SurveyFormFieldColumn.input_types.key(INPUT_SELECT_ONE_RADIO),
  ]

  MULTI_CHOICE_VALUES_TYPES = [
    SurveyFormFieldColumn.input_types.key(INPUT_SELECT_MANY)
  ]


  default_scope { order(:ordering) }
  scope :has_options, -> { where(input_type: [INPUT_SELECT_ONE_RADIO,
                                              INPUT_SELECT_ONE_DROPDOWN,
                                              INPUT_SELECT_MANY]) }

  scope :for_skip_logics, -> { where(input_type: [INPUT_SHORT_TEXT,
                                                  INPUT_LONG_TEXT,
                                                  INPUT_SELECT_ONE_RADIO,
                                                  INPUT_SELECT_ONE_DROPDOWN,
                                                  INPUT_SELECT_MANY,
                                                  INPUT_NUMBER,
                                                  INPUT_NON_NEGATIVE_NUMBER,
                                                  INPUT_DECIMAL_NUMBER,
                                                  INPUT_AUTO_INCREMENT_NUMBER]) }

  def has_custom_input?
    self.selection_input? and self.options.pluck(:custom_input).include?(true)
  end

  def selection_input?
    [SurveyFormFieldColumn.input_types.key(INPUT_SELECT_ONE_RADIO),
     SurveyFormFieldColumn.input_types.key(INPUT_SELECT_ONE_DROPDOWN),
     SurveyFormFieldColumn.input_types.key(INPUT_SELECT_MANY)].include? input_type
  end

  def text_input?
    [SurveyFormFieldColumn.input_types.key(INPUT_SHORT_TEXT),
     SurveyFormFieldColumn.input_types.key(INPUT_LONG_TEXT)].include? input_type
  end

  def number_input?
    [SurveyFormFieldColumn.input_types.key(INPUT_NUMBER),
     SurveyFormFieldColumn.input_types.key(INPUT_NON_NEGATIVE_NUMBER),
     SurveyFormFieldColumn.input_types.key(INPUT_DECIMAL_NUMBER),
     SurveyFormFieldColumn.input_types.key(INPUT_AUTO_INCREMENT_NUMBER)].include? input_type
  end

  def date_input?
    [SurveyFormFieldColumn.input_types.key(INPUT_DATE)].include? input_type
  end

  def time_input?
    [SurveyFormFieldColumn.input_types.key(INPUT_TIME)].include? input_type
  end

  def validatable?
    text_input? || number_input? || date_input?
  end

  def lock
    self.removable = false
    save ? true : false
  end

  def name
    code
  end

  def show_as
    title
  end

  def get_conditions
    if number_input?
      SurveyDependentField.translated_number_conditions
    else
      SurveyDependentField.translated_string_conditions
    end
  end

  def get_validation_conditions
    if number_input? || date_input?
      SurveyFormFieldValidation.translated_number_conditions
    else
      SurveyFormFieldValidation.translated_string_conditions
    end
  end

  def truncated_title
    ActionView::Base.full_sanitizer
                    .sanitize(self.get_local_value('title'))&.truncate(150, omission: "...#{self.get_local_value('title')&.last(10)}")
  end

  before_create :set_ordering_and_name
  before_create :set_removable

  def set_removable
    self.removable = true
  end

  def set_ordering_and_name
    max_id = SurveyFormFieldColumn.maximum(:id).to_i + 1
    unless self.code.present?
      if select_many?
        self.code = "multiChoice_column_#{max_id}"
      else
        self.code = "dynamic_field_column_#{max_id}"
      end
      self.ordering = max_id
    end
  end

  def set_name
    if select_many?
      self.code = "multiChoice_column_#{id}"
    else
      self.code = "dynamic_field_column_#{id}"
    end
  end

  def stable_id
    return id unless code.present?
    res = code.scan(/_(\d+)$/).flatten.first rescue nil
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

  def get_json_data
    data = {}
    data[:base] = self
    data[:options] = []

    options&.each do |option|
      data[:options] << option.get_json_data
    end

    data
  end
end
