class AddSellingPriceToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :selling_price, :decimal, default: 0.0
  end
end
