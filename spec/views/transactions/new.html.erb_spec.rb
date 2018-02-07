require 'rails_helper'

RSpec.describe "transactions/new", type: :view do
  before(:each) do
    assign(:transaction, Transaction.new(
      :customer_number => "MyString",
      :amount => "9.99",
      :network => "MyString",
      :transaction_code => "MyString",
      :voucher_code => "MyString"
    ))
  end

  it "renders new transaction form" do
    render

    assert_select "form[action=?][method=?]", transactions_path, "post" do

      assert_select "input[name=?]", "transaction[customer_number]"

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[network]"

      assert_select "input[name=?]", "transaction[transaction_code]"

      assert_select "input[name=?]", "transaction[voucher_code]"
    end
  end
end
