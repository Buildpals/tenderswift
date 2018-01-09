require 'rails_helper'

RSpec.describe "quantity_surveyor_rates/edit", type: :view do
  before(:each) do
    @quantity_surveyor_rate = assign(:quantity_surveyor_rate, QuantitySurveyorRate.create!(
      :sheet_name => "MyString",
      :rate => 1.5,
      :quantity_surveyor => nil,
      :boq => nil
    ))
  end

  it "renders the edit quantity_surveyor_rate form" do
    render

    assert_select "form[action=?][method=?]", quantity_surveyor_rate_path(@quantity_surveyor_rate), "post" do

      assert_select "input[name=?]", "quantity_surveyor_rate[sheet_name]"

      assert_select "input[name=?]", "quantity_surveyor_rate[rate]"

      assert_select "input[name=?]", "quantity_surveyor_rate[quantity_surveyor_id]"

      assert_select "input[name=?]", "quantity_surveyor_rate[boq_id]"
    end
  end
end
