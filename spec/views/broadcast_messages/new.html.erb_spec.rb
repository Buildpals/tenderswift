require 'rails_helper'

RSpec.describe "broadcast_messages/new", type: :view do
  before(:each) do
    assign(:broadcast_message, BroadcastMessage.new(
      :content => "MyText",
      :chatroom => nil
    ))
  end

  it "renders new broadcast_message form" do
    render

    assert_select "form[action=?][method=?]", broadcast_messages_path, "post" do

      assert_select "textarea[name=?]", "broadcast_message[content]"

      assert_select "input[name=?]", "broadcast_message[chatroom_id]"
    end
  end
end
