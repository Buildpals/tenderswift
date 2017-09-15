require 'rails_helper'

RSpec.describe "chatrooms/edit", type: :view do
  before(:each) do
    @chatroom = assign(:chatroom, Chatroom.create!(
      :request_for_tender => nil
    ))
  end

  it "renders the edit chatroom form" do
    render

    assert_select "form[action=?][method=?]", chatroom_path(@chatroom), "post" do

      assert_select "input[name=?]", "chatroom[request_for_tender_id]"
    end
  end
end
