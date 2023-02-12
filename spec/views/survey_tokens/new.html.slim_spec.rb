require 'rails_helper'

RSpec.describe "survey_tokens/new", type: :view do
  before(:each) do
    assign(:survey_token, SurveyToken.new())
  end

  it "renders new survey_token form" do
    render

    assert_select "form[action=?][method=?]", survey_tokens_path, "post" do
    end
  end
end
