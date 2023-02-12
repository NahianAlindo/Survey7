require 'rails_helper'

RSpec.describe "survey_projects/new", type: :view do
  before(:each) do
    assign(:survey_project, SurveyProject.new())
  end

  it "renders new survey_project form" do
    render

    assert_select "form[action=?][method=?]", survey_projects_path, "post" do
    end
  end
end
