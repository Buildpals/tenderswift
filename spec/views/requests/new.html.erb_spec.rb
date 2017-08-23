require 'rails_helper'

RSpec.describe "requests/new", type: :view do
  before(:each) do
    assign(:request, Request.new(
      :project_name => "MyString",
      :country => "MyString",
      :city => "MyString",
      :description => "MyString",
      :budget => "MyString"
    ))
  end

  it "renders new request form" do
    render

    assert_select "form[action=?][method=?]", requests_path, "post" do

      assert_select "input[name=?]", "request[project_name]"

      assert_select "input[name=?]", "request[country]"

      assert_select "input[name=?]", "request[city]"

      assert_select "input[name=?]", "request[description]"

      assert_select "input[name=?]", "request[budget]"
    end
  end
end
