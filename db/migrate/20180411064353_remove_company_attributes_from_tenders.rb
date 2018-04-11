class RemoveCompanyAttributesFromTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenders, :company_name, :string
    remove_column :tenders, :email, :string
    remove_column :tenders, :phone_number, :string
  end
end
