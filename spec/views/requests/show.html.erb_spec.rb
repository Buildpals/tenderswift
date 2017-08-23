require 'rails_helper'

RSpec.describe "requests/show", type: :view do
  before(:each) do
    @request = assign(:request, Request.create!(
      :project_name => "Project Name",
      :country => "Country",
      :city => "City",
      :description => "Description",
      :budget => "Budget"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Project Name/)
    expect(rendered).to match(/Country/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Budget/)
  end
end
