require 'rails_helper'

RSpec.describe "requests/index", type: :view do
  before(:each) do
    assign(:requests, [
      Request.create!(
        :project_name => "Project Name",
        :country => "Country",
        :city => "City",
        :description => "Description",
        :budget => "Budget"
      ),
      Request.create!(
        :project_name => "Project Name",
        :country => "Country",
        :city => "City",
        :description => "Description",
        :budget => "Budget"
      )
    ])
  end

  it "renders a list of requests" do
    render
    assert_select "tr>td", :text => "Project Name".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Budget".to_s, :count => 2
  end
end
