require 'rails_helper'

RSpec.describe "answer_boxes/edit", type: :view do
  before(:each) do
    @answer_box = assign(:answer_box, AnswerBox.create!(
      :question => nil,
      :participant => nil,
      :answer => "MyString"
    ))
  end

  it "renders the edit answer_box form" do
    render

    assert_select "form[action=?][method=?]", answer_box_path(@answer_box), "post" do

      assert_select "input[name=?]", "answer_box[question_id]"

      assert_select "input[name=?]", "answer_box[participant_id]"

      assert_select "input[name=?]", "answer_box[answer]"
    end
  end
end
