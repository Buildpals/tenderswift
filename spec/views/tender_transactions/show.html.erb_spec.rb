require 'rails_helper'

RSpec.describe "tender_transactions/show", type: :view do
  before(:each) do
    @tender_transaction = assign(:tender_transaction, TenderTransaction.create!(
      :customer_number => "Customer Number",
      :amount => "9.99",
      :transaction_id => "Transaction",
      :voucher_code => "Voucher Code",
      :network_code => "Network Code",
      :status => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Customer Number/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Transaction/)
    expect(rendered).to match(/Voucher Code/)
    expect(rendered).to match(/Network Code/)
    expect(rendered).to match(/2/)
  end
end
