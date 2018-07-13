class ChangeColumnNameContractSumAddressToTenderFigure < ActiveRecord::Migration[5.1]
  def change
    rename_column :request_for_tenders,
                  :contract_sum_address,
                  :tender_figure_address
  end
end
