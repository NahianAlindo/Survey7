class SurveyDependentField < ApplicationRecord
  belongs_to :survey_form_field, optional: true
  belongs_to :logic_field, polymorphic: true, optional: true
  belongs_to :survey_form_section, optional: true
  belongs_to :survey_form_section_subsection, optional: true
  belongs_to :survey_form_field_column, optional: true
  belongs_to :survey_form_field_option, optional: true

  alias_attribute :option, :survey_form_field_option
  alias_attribute :field, :survey_form_field
  alias_attribute :section, :survey_form_section
  alias_attribute :subsection, :survey_form_section_subsection
  alias_attribute :column, :survey_form_field_column

  STRING_CONDITIONS = [
    ["equal", "equal", "সমান"],
    ["not_equal", "not equal", "সমান নয়"]
  ]

  NUMBER_CONDITIONS = [
    ["equal", "equal", "সমান"],
    ["not_equal", "not equal", "সমান নয়"],
    ["greater_than", "greater than", "বড় হবে"],
    ["less_than", "less than", "ছোট হবে"]
  ]

  enum condition_type: {
    equal: 0,
    not_equal: 1,
    greater_than: 2,
    less_than: 3
  }

  def translated_condition_type
    return condition_type unless I18n.locale == :bn

    case condition_type
    when 'equal'
      'সমান'
    when 'not_equal'
      'সমান নয়'
    when 'greater_than'
      'বড় হবে'
    when 'less_than'
      'ছোট হবে'
    end
  end
  def self.translated_string_conditions
    conditions = []
    STRING_CONDITIONS.each do |condition|
      value = (I18n.locale == :bn) ? condition[2] : condition[1]
      conditions << [condition[0], value]
    end
    conditions
  end

  def self.translated_number_conditions
    conditions = []
    NUMBER_CONDITIONS.each do |condition|
      value = (I18n.locale == :bn) ? condition[2] : condition[1]
      conditions << [condition[0], value]
    end
    conditions
  end

  def valid_data?
    option.present? || value.present?
  end

  def logic_value
    if option.present?
      option.get_local_value('label')
    elsif value.present?
      value
    else
      '-'
    end
  end

  def formatted_logic_value
    if option.present?
      option.formatted_value
    elsif value.present?
      value
    else
      ''
    end
  end

  def get_local_value_label
    self.get_local_value('label')
  end

  def parent_field
    if logic_field.present?
      logic_field
    elsif option.present?
      if option.survey_form_field.present?
        option.survey_form_field
      elsif option.column.present?
        option.column
      end
    end
  end

  after_destroy :check_all_logic_status
  before_save :sanitize_params

  def sanitize_params
    self.value = value&.strip if value.present?
  end

  def check_all_logic_status
    SurveyManager::CheckAllLogicStatus.call(self)
  end
end
