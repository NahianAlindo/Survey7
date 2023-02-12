require 'rails_helper'

RSpec.describe "survey_tokens/show", type: :view do
  before(:each) do
    assign(:survey_token, SurveyToken.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
