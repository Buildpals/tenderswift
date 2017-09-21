require 'rails_helper'

RSpec.describe "answer_boxes/index", type: :view do
  before(:each) do
    assign(:answer_boxes, [
      AnswerBox.create!(
        :question => nil,
        :participant => nil,
        :answer => "Answer"
      ),
      AnswerBox.create!(
        :question => nil,
        :participant => nil,
        :answer => "Answer"
      )
    ])
  end

  it "renders a list of answer_boxes" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Answer".to_s, :count => 2
  end
end
