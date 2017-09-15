require 'rails_helper'

RSpec.describe "chatrooms/new", type: :view do
  before(:each) do
    assign(:chatroom, Chatroom.new(
      :request_for_tender => nil
    ))
  end

  it "renders new chatroom form" do
    render

    assert_select "form[action=?][method=?]", chatrooms_path, "post" do

      assert_select "input[name=?]", "chatroom[request_for_tender_id]"
    end
  end
end
