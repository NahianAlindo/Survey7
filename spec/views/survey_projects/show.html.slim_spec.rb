require 'rails_helper'

RSpec.describe "survey_projects/show", type: :view do
  before(:each) do
    assign(:survey_project, SurveyProject.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
