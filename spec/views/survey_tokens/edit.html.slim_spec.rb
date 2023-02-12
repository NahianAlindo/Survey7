require 'rails_helper'

RSpec.describe "survey_tokens/edit", type: :view do
  let(:survey_token) {
    SurveyToken.create!()
  }

  before(:each) do
    assign(:survey_token, survey_token)
  end

  it "renders the edit survey_token form" do
    render

    assert_select "form[action=?][method=?]", survey_token_path(survey_token), "post" do
    end
  end
end
