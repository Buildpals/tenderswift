require 'rails_helper'

RSpec.describe "broadcast_messages/show", type: :view do
  before(:each) do
    @broadcast_message = assign(:broadcast_message, BroadcastMessage.create!(
      :content => "MyText",
      :chatroom => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
