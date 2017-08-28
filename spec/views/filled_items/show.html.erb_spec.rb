require 'rails_helper'

RSpec.describe "filled_items/show", type: :view do
  before(:each) do
    @filled_item = assign(:filled_item, FilledItem.create!(
      :amount => "Amount",
      :rate => "Rate",
      :participant => nil,
      :item => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Amount/)
    expect(rendered).to match(/Rate/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
