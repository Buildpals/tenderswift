class ChangeCompanyNameInContractor < ActiveRecord::Migration[5.1]
  def change
    change_column :contractors, :company_name, :string
  end
end
