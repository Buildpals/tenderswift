require 'rails_helper'

RSpec.describe "boqs/edit", type: :view do
  before(:each) do
    @boq = assign(:boq, Boq.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit boq form" do
    render

    assert_select "form[action=?][method=?]", boq_path(@boq), "post" do

      assert_select "input[name=?]", "boq[name]"
    end
  end
end
