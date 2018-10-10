class RemoveCurrencyFromRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders,
                  :currency,
                  :string,
                  default: "GHS",
                  null: false
  end
end
