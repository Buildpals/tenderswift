require 'rails_helper'

RSpec.describe "answer_boxes/new", type: :view do
  before(:each) do
    assign(:answer_box, AnswerBox.new(
      :question => nil,
      :participant => nil,
      :answer => "MyString"
    ))
  end

  it "renders new answer_box form" do
    render

    assert_select "form[action=?][method=?]", answer_boxes_path, "post" do

      assert_select "input[name=?]", "answer_box[question_id]"

      assert_select "input[name=?]", "answer_box[participant_id]"

      assert_select "input[name=?]", "answer_box[answer]"
    end
  end
end
