require 'rails_helper'

RSpec.describe "filled_items/edit", type: :view do
  before(:each) do
    @filled_item = assign(:filled_item, FilledItem.create!(
      :amount => "MyString",
      :rate => "MyString",
      :participant => nil,
      :item => nil
    ))
  end

  it "renders the edit filled_item form" do
    render

    assert_select "form[action=?][method=?]", filled_item_path(@filled_item), "post" do

      assert_select "input[name=?]", "filled_item[amount]"

      assert_select "input[name=?]", "filled_item[rate]"

      assert_select "input[name=?]", "filled_item[participant_id]"

      assert_select "input[name=?]", "filled_item[item_id]"
    end
  end
end
