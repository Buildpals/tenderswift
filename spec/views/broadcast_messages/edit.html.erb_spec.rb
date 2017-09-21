require 'rails_helper'

RSpec.describe "broadcast_messages/edit", type: :view do
  before(:each) do
    @broadcast_message = assign(:broadcast_message, BroadcastMessage.create!(
      :content => "MyText",
      :chatroom => nil
    ))
  end

  it "renders the edit broadcast_message form" do
    render

    assert_select "form[action=?][method=?]", broadcast_message_path(@broadcast_message), "post" do

      assert_select "textarea[name=?]", "broadcast_message[content]"

      assert_select "input[name=?]", "broadcast_message[chatroom_id]"
    end
  end
end
