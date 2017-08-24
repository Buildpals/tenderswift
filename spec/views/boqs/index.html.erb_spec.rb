require 'rails_helper'

RSpec.describe "boqs/index", type: :view do
  before(:each) do
    assign(:boqs, [
      Boq.create!(
        :name => "Name"
      ),
      Boq.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of boqs" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
