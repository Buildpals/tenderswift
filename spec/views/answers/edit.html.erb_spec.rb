require 'rails_helper'

RSpec.describe "answers/edit", type: :view do
  before(:each) do
    @answer = assign(:answer, Answer.create!(
      :question => nil,
      :participant => nil,
      :answer => "MyString"
    ))
  end

  it "renders the edit answer form" do
    render

    assert_select "form[action=?][method=?]", answer_path(@answer), "post" do

      assert_select "input[name=?]", "answer[question_id]"

      assert_select "input[name=?]", "answer[participant_id]"

      assert_select "input[name=?]", "answer[answer]"
    end
  end
end
