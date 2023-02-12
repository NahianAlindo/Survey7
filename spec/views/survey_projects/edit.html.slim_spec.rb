require 'rails_helper'

RSpec.describe "survey_projects/edit", type: :view do
  let(:survey_project) {
    SurveyProject.create!()
  }

  before(:each) do
    assign(:survey_project, survey_project)
  end

  it "renders the edit survey_project form" do
    render

    assert_select "form[action=?][method=?]", survey_project_path(survey_project), "post" do
    end
  end
end
