require 'rails_helper'

RSpec.describe "filled_items/index", type: :view do
  before(:each) do
    assign(:filled_items, [
      FilledItem.create!(
        :amount => "Amount",
        :rate => "Rate",
        :participant => nil,
        :item => nil
      ),
      FilledItem.create!(
        :amount => "Amount",
        :rate => "Rate",
        :participant => nil,
        :item => nil
      )
    ])
  end

  it "renders a list of filled_items" do
    render
    assert_select "tr>td", :text => "Amount".to_s, :count => 2
    assert_select "tr>td", :text => "Rate".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
