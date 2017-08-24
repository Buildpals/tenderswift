require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :name => "MyString",
      :description => "MyText",
      :rate => "MyString",
      :quantity => "MyString",
      :rate => "MyString",
      :amount => "MyString"
    ))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "textarea[name=?]", "item[description]"

      assert_select "input[name=?]", "item[rate]"

      assert_select "input[name=?]", "item[quantity]"

      assert_select "input[name=?]", "item[rate]"

      assert_select "input[name=?]", "item[amount]"
    end
  end
end
