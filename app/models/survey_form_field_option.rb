class SurveyFormFieldOption < ApplicationRecord
  belongs_to :survey_form_field, optional: true
  belongs_to :survey_form_field_column, optional: true

  has_many :survey_dependent_fields, dependent: :destroy
  has_many :survey_form_fields, through: :survey_dependent_fields

  validates :label, length: { maximum: 4_294_967_294 }

  alias_attribute :parent, :survey_form_field
  alias_attribute :column, :survey_form_field_column

  def formatted_value
    if custom_input?
      "['#{label}', #{coalesce value}, 'custom_input', '#{name}']"
    else
      "['#{label}', #{coalesce value}, '#{name}']"
    end
  end

  def coalesce(value, ret=0)
    value.nil? ? ret : value
  end

  def stable_id
    return id unless name.present?
    res = name.scan(/_(\d+)$/).flatten.first rescue nil
    return id unless res.present?
    res.to_i
  end

  before_create :set_name

  def set_name
    if id.present?
      self.name = "dynamic_field_option_#{id}"
    else
      max_id = SurveyFormFieldOption.maximum(:id).to_i + 1
      self.name = "dynamic_field_option_#{max_id}" unless self.name.present?
    end
  end

  def get_json_data
    data = {}
    data[:base] = self

    data
  end
end
