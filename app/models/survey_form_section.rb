class SurveyFormSection < ApplicationRecord
  belongs_to :survey_form

  has_many :survey_form_fields, dependent: :destroy
  has_many :survey_form_section_subsections, dependent: :destroy
  has_many :survey_dependent_fields, dependent: :destroy

  validates :title, length: { maximum: 250 }
  validates :code, length: { maximum: 250 }

  accepts_nested_attributes_for :survey_form_section_subsections,
                                allow_destroy: true,
                                reject_if: proc { |att| att['title'].blank? }

  alias_attribute :subsections, :survey_form_section_subsections
  alias_attribute :fields, :survey_form_fields
  alias_attribute :dependent_fields, :survey_dependent_fields

  amoeba do
    enable
    include_association :survey_form_fields
    include_association :survey_form_section_subsections
  end

  default_scope { order(:ordering) }

  before_create :set_ordering_and_code
  before_create :set_removable

  def set_removable
    self.removable = true
  end

  def lock
    self.removable = false
    save ? true : false
  end

  def set_ordering_and_code
    max_id = SurveyFormSection.maximum(:id).to_i + 1
    unless self.code.present?
      self.code = "dynamic_section_#{max_id}"
      self.ordering = max_id
    end
  end

  def first_field_ordering
    field = fields.first
    return field.ordering if field.present?

    subsections&.first&.fields&.first&.ordering
  end

  def stable_id
    return id unless code.present?
    res = code.scan(/_(\d+)$/).flatten.first rescue nil
    return id unless res.present?
    res.to_i
  end

  def get_json_data
    data = {}
    data[:base] = self
    data[:fields]      = []
    data[:subsections] = []
    fields&.each do |field|
      data[:fields] << field.get_json_data
    end

    subsections&.each do |subsection|
      data[:subsections] << subsection.get_json_data
    end

    data
  end
end
