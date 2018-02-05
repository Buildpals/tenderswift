require 'rails_helper'

RSpec.describe "transactions/show", type: :view do
  before(:each) do
    @transaction = assign(:transaction, Transaction.create!(
      :customer_number => "Customer Number",
      :amount => "9.99",
      :network => "Network",
      :transaction_code => "Transaction Code",
      :voucher_code => "Voucher Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Customer Number/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Network/)
    expect(rendered).to match(/Transaction Code/)
    expect(rendered).to match(/Voucher Code/)
  end
end
