require 'rails_helper'

RSpec.describe "survey_projects/index", type: :view do
  before(:each) do
    assign(:survey_projects, [
      SurveyProject.create!(),
      SurveyProject.create!()
    ])
  end

  it "renders a list of survey_projects" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
