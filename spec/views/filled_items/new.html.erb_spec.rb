require 'rails_helper'

RSpec.describe "filled_items/new", type: :view do
  before(:each) do
    assign(:filled_item, FilledItem.new(
      :amount => "MyString",
      :rate => "MyString",
      :participant => nil,
      :item => nil
    ))
  end

  it "renders new filled_item form" do
    render

    assert_select "form[action=?][method=?]", filled_items_path, "post" do

      assert_select "input[name=?]", "filled_item[amount]"

      assert_select "input[name=?]", "filled_item[rate]"

      assert_select "input[name=?]", "filled_item[participant_id]"

      assert_select "input[name=?]", "filled_item[item_id]"
    end
  end
end
