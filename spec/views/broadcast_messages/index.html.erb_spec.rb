require 'rails_helper'

RSpec.describe "broadcast_messages/index", type: :view do
  before(:each) do
    assign(:broadcast_messages, [
      BroadcastMessage.create!(
        :content => "MyText",
        :chatroom => nil
      ),
      BroadcastMessage.create!(
        :content => "MyText",
        :chatroom => nil
      )
    ])
  end

  it "renders a list of broadcast_messages" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
