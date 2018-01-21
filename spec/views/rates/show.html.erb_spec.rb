require 'rails_helper'

RSpec.describe "rates/show", type: :view do
  before(:each) do
    @rate = assign(:rate, Rate.create!(
      :sheet_name => "Sheet Name",
      :row => 2,
      :value => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Sheet Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
