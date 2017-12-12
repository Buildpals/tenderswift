require 'rails_helper'

RSpec.describe "rates/edit", type: :view do
  before(:each) do
    @rate = assign(:rate, Rate.create!(
      :sheet_name => "MyString",
      :row => 1,
      :value => 1
    ))
  end

  it "renders the edit rate form" do
    render

    assert_select "form[action=?][method=?]", rate_path(@rate), "post" do

      assert_select "input[name=?]", "rate[sheet_name]"

      assert_select "input[name=?]", "rate[row]"

      assert_select "input[name=?]", "rate[value]"
    end
  end
end
