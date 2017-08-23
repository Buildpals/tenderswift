require 'rails_helper'

RSpec.describe "participants/edit", type: :view do
  before(:each) do
    @participant = assign(:participant, Participant.create!(
      :email => "MyString",
      :phone_number => "MyString"
    ))
  end

  it "renders the edit participant form" do
    render

    assert_select "form[action=?][method=?]", participant_path(@participant), "post" do

      assert_select "input[name=?]", "participant[email]"

      assert_select "input[name=?]", "participant[phone_number]"
    end
  end
end
