require 'rails_helper'

RSpec.describe "participants/new", type: :view do
  before(:each) do
    assign(:participant, Participant.new(
      :email => "MyString",
      :phone_number => "MyString"
    ))
  end

  it "renders new participant form" do
    render

    assert_select "form[action=?][method=?]", participants_path, "post" do

      assert_select "input[name=?]", "participant[email]"

      assert_select "input[name=?]", "participant[phone_number]"
    end
  end
end
