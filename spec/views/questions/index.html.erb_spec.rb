require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  before(:each) do
    assign(:questions, [
      Question.create!(
        :request_for_tender => nil,
        :number => 2,
        :title => "Title",
        :description => "MyText",
        :question_type => 3,
        :can_attach_documents => false,
        :mandatory => false,
        :choices => "MyText"
      ),
      Question.create!(
        :request_for_tender => nil,
        :number => 2,
        :title => "Title",
        :description => "MyText",
        :question_type => 3,
        :can_attach_documents => false,
        :mandatory => false,
        :choices => "MyText"
      )
    ])
  end

  it "renders a list of questions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
