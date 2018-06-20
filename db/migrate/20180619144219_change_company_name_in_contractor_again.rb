class ChangeCompanyNameInContractorAgain < ActiveRecord::Migration[5.1]
  def change
    change_column :contractors, :company_name, :string, null: true
  end
end
