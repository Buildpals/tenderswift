require 'rails_helper'

RSpec.describe "chatrooms/index", type: :view do
  before(:each) do
    assign(:chatrooms, [
      Chatroom.create!(
        :request_for_tender => nil
      ),
      Chatroom.create!(
        :request_for_tender => nil
      )
    ])
  end

  it "renders a list of chatrooms" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
