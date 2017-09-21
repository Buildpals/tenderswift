require 'rails_helper'

RSpec.describe "messages/new", type: :view do
  before(:each) do
    assign(:message, Message.new(
      :content => "MyText",
      :broadcast_message => nil,
      :participant => nil
    ))
  end

  it "renders new message form" do
    render

    assert_select "form[action=?][method=?]", messages_path, "post" do

      assert_select "textarea[name=?]", "message[content]"

      assert_select "input[name=?]", "message[broadcast_message_id]"

      assert_select "input[name=?]", "message[participant_id]"
    end
  end
end
