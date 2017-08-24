require 'rails_helper'

RSpec.describe "boqs/show", type: :view do
  before(:each) do
    @boq = assign(:boq, Boq.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
