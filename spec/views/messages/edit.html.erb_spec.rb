require 'rails_helper'

RSpec.describe "messages/edit", type: :view do
  before(:each) do
    @message = assign(:message, Message.create!(
      :content => "MyText",
      :broadcast_message => nil,
      :participant => nil
    ))
  end

  it "renders the edit message form" do
    render

    assert_select "form[action=?][method=?]", message_path(@message), "post" do

      assert_select "textarea[name=?]", "message[content]"

      assert_select "input[name=?]", "message[broadcast_message_id]"

      assert_select "input[name=?]", "message[participant_id]"
    end
  end
end
