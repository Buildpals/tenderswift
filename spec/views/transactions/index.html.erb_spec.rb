require 'rails_helper'

RSpec.describe "transactions/index", type: :view do
  before(:each) do
    assign(:transactions, [
      Transaction.create!(
        :customer_number => "Customer Number",
        :amount => "9.99",
        :network => "Network",
        :transaction_code => "Transaction Code",
        :voucher_code => "Voucher Code"
      ),
      Transaction.create!(
        :customer_number => "Customer Number",
        :amount => "9.99",
        :network => "Network",
        :transaction_code => "Transaction Code",
        :voucher_code => "Voucher Code"
      )
    ])
  end

  it "renders a list of transactions" do
    render
    assert_select "tr>td", :text => "Customer Number".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Network".to_s, :count => 2
    assert_select "tr>td", :text => "Transaction Code".to_s, :count => 2
    assert_select "tr>td", :text => "Voucher Code".to_s, :count => 2
  end
end
