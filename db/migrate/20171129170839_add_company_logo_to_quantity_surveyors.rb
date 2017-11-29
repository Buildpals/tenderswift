class AddCompanyLogoToQuantitySurveyors < ActiveRecord::Migration[5.1]
  def change
    add_column :quantity_surveyors, :company_logo, :string
  end
end
