require 'rails_helper'

RSpec.describe "surveys/new", type: :view do
  before(:each) do
    assign(:survey, Survey.new())
  end

  it "renders new survey form" do
    render

    assert_select "form[action=?][method=?]", surveys_path, "post" do
    end
  end
end
