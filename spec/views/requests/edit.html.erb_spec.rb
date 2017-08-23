require 'rails_helper'

RSpec.describe "requests/edit", type: :view do
  before(:each) do
    @request = assign(:request, Request.create!(
      :project_name => "MyString",
      :country => "MyString",
      :city => "MyString",
      :description => "MyString",
      :budget => "MyString"
    ))
  end

  it "renders the edit request form" do
    render

    assert_select "form[action=?][method=?]", request_path(@request), "post" do

      assert_select "input[name=?]", "request[project_name]"

      assert_select "input[name=?]", "request[country]"

      assert_select "input[name=?]", "request[city]"

      assert_select "input[name=?]", "request[description]"

      assert_select "input[name=?]", "request[budget]"
    end
  end
end
