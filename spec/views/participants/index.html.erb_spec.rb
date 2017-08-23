require 'rails_helper'

RSpec.describe "participants/index", type: :view do
  before(:each) do
    assign(:participants, [
      Participant.create!(
        :email => "Email",
        :phone_number => "Phone Number"
      ),
      Participant.create!(
        :email => "Email",
        :phone_number => "Phone Number"
      )
    ])
  end

  it "renders a list of participants" do
    render
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Number".to_s, :count => 2
  end
end
