require 'rails_helper'

RSpec.describe "sections/edit", type: :view do
  before(:each) do
    @section = assign(:section, Section.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit section form" do
    render

    assert_select "form[action=?][method=?]", section_path(@section), "post" do

      assert_select "input[name=?]", "section[name]"
    end
  end
end
