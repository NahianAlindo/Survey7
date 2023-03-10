require 'rails_helper'

RSpec.describe "surveys/show", type: :view do
  before(:each) do
    assign(:survey, Survey.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
