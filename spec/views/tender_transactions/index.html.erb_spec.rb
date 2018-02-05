require 'rails_helper'

RSpec.describe "tender_transactions/index", type: :view do
  before(:each) do
    assign(:tender_transactions, [
      TenderTransaction.create!(
        :customer_number => "Customer Number",
        :amount => "9.99",
        :transaction_id => "Transaction",
        :voucher_code => "Voucher Code",
        :network_code => "Network Code",
        :status => 2
      ),
      TenderTransaction.create!(
        :customer_number => "Customer Number",
        :amount => "9.99",
        :transaction_id => "Transaction",
        :voucher_code => "Voucher Code",
        :network_code => "Network Code",
        :status => 2
      )
    ])
  end

  it "renders a list of tender_transactions" do
    render
    assert_select "tr>td", :text => "Customer Number".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Transaction".to_s, :count => 2
    assert_select "tr>td", :text => "Voucher Code".to_s, :count => 2
    assert_select "tr>td", :text => "Network Code".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
