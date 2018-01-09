require 'rails_helper'

RSpec.describe "quantity_surveyor_rates/show", type: :view do
  before(:each) do
    @quantity_surveyor_rate = assign(:quantity_surveyor_rate, QuantitySurveyorRate.create!(
      :sheet_name => "Sheet Name",
      :rate => 2.5,
      :quantity_surveyor => nil,
      :boq => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Sheet Name/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
