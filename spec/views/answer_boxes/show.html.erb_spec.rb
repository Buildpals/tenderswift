require 'rails_helper'

RSpec.describe "answer_boxes/show", type: :view do
  before(:each) do
    @answer_box = assign(:answer_box, AnswerBox.create!(
      :question => nil,
      :participant => nil,
      :answer => "Answer"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Answer/)
  end
end
