# frozen_string_literal: true

class AddContractClassToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders,
               :contract_class,
               :string
  end
end
