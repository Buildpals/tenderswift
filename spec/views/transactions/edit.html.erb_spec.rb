require 'rails_helper'

RSpec.describe "transactions/edit", type: :view do
  before(:each) do
    @transaction = assign(:transaction, Transaction.create!(
      :customer_number => "MyString",
      :amount => "9.99",
      :network => "MyString",
      :transaction_code => "MyString",
      :voucher_code => "MyString"
    ))
  end

  it "renders the edit transaction form" do
    render

    assert_select "form[action=?][method=?]", transaction_path(@transaction), "post" do

      assert_select "input[name=?]", "transaction[customer_number]"

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[network]"

      assert_select "input[name=?]", "transaction[transaction_code]"

      assert_select "input[name=?]", "transaction[voucher_code]"
    end
  end
end
