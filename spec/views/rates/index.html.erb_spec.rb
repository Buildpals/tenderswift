require 'rails_helper'

RSpec.describe "rates/index", type: :view do
  before(:each) do
    assign(:rates, [
      Rate.create!(
        :sheet_name => "Sheet Name",
        :row => 2,
        :value => 3
      ),
      Rate.create!(
        :sheet_name => "Sheet Name",
        :row => 2,
        :value => 3
      )
    ])
  end

  it "renders a list of rates" do
    render
    assert_select "tr>td", :text => "Sheet Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
