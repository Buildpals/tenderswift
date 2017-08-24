require 'rails_helper'

RSpec.describe "boqs/new", type: :view do
  before(:each) do
    assign(:boq, Boq.new(
      :name => "MyString"
    ))
  end

  it "renders new boq form" do
    render

    assert_select "form[action=?][method=?]", boqs_path, "post" do

      assert_select "input[name=?]", "boq[name]"
    end
  end
end
