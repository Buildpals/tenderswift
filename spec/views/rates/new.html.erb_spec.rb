require 'rails_helper'

RSpec.describe "rates/new", type: :view do
  before(:each) do
    assign(:rate, Rate.new(
      :sheet_name => "MyString",
      :row => 1,
      :value => 1
    ))
  end

  it "renders new rate form" do
    render

    assert_select "form[action=?][method=?]", rates_path, "post" do

      assert_select "input[name=?]", "rate[sheet_name]"

      assert_select "input[name=?]", "rate[row]"

      assert_select "input[name=?]", "rate[value]"
    end
  end
end
