require 'rails_helper'

RSpec.describe "items/show", type: :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :name => "Name",
      :description => "MyText",
      :rate => "Rate",
      :quantity => "Quantity",
      :rate => "Rate",
      :amount => "Amount"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Rate/)
    expect(rendered).to match(/Quantity/)
    expect(rendered).to match(/Rate/)
    expect(rendered).to match(/Amount/)
  end
end
