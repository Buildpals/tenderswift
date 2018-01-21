require 'rails_helper'

RSpec.describe "quantity_surveyor_rates/index", type: :view do
  before(:each) do
    assign(:quantity_surveyor_rates, [
      QuantitySurveyorRate.create!(
        :sheet_name => "Sheet Name",
        :rate => 2.5,
        :quantity_surveyor => nil,
        :boq => nil
      ),
      QuantitySurveyorRate.create!(
        :sheet_name => "Sheet Name",
        :rate => 2.5,
        :quantity_surveyor => nil,
        :boq => nil
      )
    ])
  end

  it "renders a list of quantity_surveyor_rates" do
    render
    assert_select "tr>td", :text => "Sheet Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
