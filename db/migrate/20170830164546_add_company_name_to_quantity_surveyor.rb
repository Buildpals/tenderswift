class AddCompanyNameToQuantitySurveyor < ActiveRecord::Migration[5.1]
  def change
    add_column :quantity_surveyors, :company_name, :string
  end
end
