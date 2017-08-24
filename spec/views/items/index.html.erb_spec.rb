require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        :name => "Name",
        :description => "MyText",
        :rate => "Rate",
        :quantity => "Quantity",
        :rate => "Rate",
        :amount => "Amount"
      ),
      Item.create!(
        :name => "Name",
        :description => "MyText",
        :rate => "Rate",
        :quantity => "Quantity",
        :rate => "Rate",
        :amount => "Amount"
      )
    ])
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Rate".to_s, :count => 2
    assert_select "tr>td", :text => "Quantity".to_s, :count => 2
    assert_select "tr>td", :text => "Rate".to_s, :count => 2
    assert_select "tr>td", :text => "Amount".to_s, :count => 2
  end
end
