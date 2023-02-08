class SurveyFormSectionSubsection < ApplicationRecord
  belongs_to :survey_form
  belongs_to :survey_form_section

  has_many :survey_form_fields, dependent: :destroy
  has_many :survey_dependent_fields, dependent: :destroy

  validates :title, length: { maximum: 250 }
  validates :code, length: { maximum: 250 }

  alias_attribute :section, :survey_form_section
  alias_attribute :fields, :survey_form_fields
  alias_attribute :dependent_fields, :survey_dependent_fields

  amoeba do
    enable
    include_association :survey_form_fields
  end

  default_scope { order(:ordering) }

  def lock
    self.removable = false
    save ? true : false
  end

  before_create :set_ordering_and_code
  before_create :set_removable

  def set_removable
    self.removable = true
  end

  def set_ordering_and_code
    max_id = SurveyFormSectionSubsection.maximum(:id).to_i + 1
    unless self.code.present?
      self.code = "dynamic_subsection_#{max_id}"
      self.ordering = max_id
    end
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
    data[:fields] = []
    fields&.each do |field|
      data[:fields] << field.get_json_data
    end

    data
  end
end
