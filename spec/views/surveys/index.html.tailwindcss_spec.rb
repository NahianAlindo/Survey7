require 'rails_helper'

RSpec.describe "surveys/index", type: :view do
  before(:each) do
    assign(:surveys, [
      Survey.create!(),
      Survey.create!()
    ])
  end

  it "renders a list of surveys" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
