require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      :name => "MyString",
      :description => "MyText",
      :rate => "MyString",
      :quantity => "MyString",
      :rate => "MyString",
      :amount => "MyString"
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input[name=?]", "item[name]"

      assert_select "textarea[name=?]", "item[description]"

      assert_select "input[name=?]", "item[rate]"

      assert_select "input[name=?]", "item[quantity]"

      assert_select "input[name=?]", "item[rate]"

      assert_select "input[name=?]", "item[amount]"
    end
  end
end
