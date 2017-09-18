require 'rails_helper'

RSpec.describe "answers/index", type: :view do
  before(:each) do
    assign(:answers, [
      Answer.create!(
        :question => nil,
        :participant => nil,
        :answer => "Answer"
      ),
      Answer.create!(
        :question => nil,
        :participant => nil,
        :answer => "Answer"
      )
    ])
  end

  it "renders a list of answers" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Answer".to_s, :count => 2
  end
end
