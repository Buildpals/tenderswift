require 'rails_helper'

RSpec.describe "tender_transactions/edit", type: :view do
  before(:each) do
    @tender_transaction = assign(:tender_transaction, TenderTransaction.create!(
      :customer_number => "MyString",
      :amount => "9.99",
      :transaction_id => "MyString",
      :voucher_code => "MyString",
      :network_code => "MyString",
      :status => 1
    ))
  end

  it "renders the edit tender_transaction form" do
    render

    assert_select "form[action=?][method=?]", tender_transaction_path(@tender_transaction), "post" do

      assert_select "input[name=?]", "tender_transaction[customer_number]"

      assert_select "input[name=?]", "tender_transaction[amount]"

      assert_select "input[name=?]", "tender_transaction[transaction_id]"

      assert_select "input[name=?]", "tender_transaction[voucher_code]"

      assert_select "input[name=?]", "tender_transaction[network_code]"

      assert_select "input[name=?]", "tender_transaction[status]"
    end
  end
end
