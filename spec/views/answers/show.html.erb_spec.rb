require 'rails_helper'

RSpec.describe "answers/show", type: :view do
  before(:each) do
    @answer = assign(:answer, Answer.create!(
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
