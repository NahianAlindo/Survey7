require 'rails_helper'

RSpec.describe "survey_tokens/index", type: :view do
  before(:each) do
    assign(:survey_tokens, [
      SurveyToken.create!(),
      SurveyToken.create!()
    ])
  end

  it "renders a list of survey_tokens" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
