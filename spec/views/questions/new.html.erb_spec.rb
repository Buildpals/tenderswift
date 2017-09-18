require 'rails_helper'

RSpec.describe "questions/new", type: :view do
  before(:each) do
    assign(:question, Question.new(
      :request_for_tender => nil,
      :number => 1,
      :title => "MyString",
      :description => "MyText",
      :question_type => 1,
      :can_attach_documents => false,
      :mandatory => false,
      :choices => "MyText"
    ))
  end

  it "renders new question form" do
    render

    assert_select "form[action=?][method=?]", questions_path, "post" do

      assert_select "input[name=?]", "question[request_for_tender_id]"

      assert_select "input[name=?]", "question[number]"

      assert_select "input[name=?]", "question[title]"

      assert_select "textarea[name=?]", "question[description]"

      assert_select "input[name=?]", "question[question_type]"

      assert_select "input[name=?]", "question[can_attach_documents]"

      assert_select "input[name=?]", "question[mandatory]"

      assert_select "textarea[name=?]", "question[choices]"
    end
  end
end
