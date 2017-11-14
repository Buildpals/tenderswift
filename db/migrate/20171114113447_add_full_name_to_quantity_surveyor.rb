class AddFullNameToQuantitySurveyor < ActiveRecord::Migration[5.1]
  def change
    add_column :quantity_surveyors, :full_name, :string
  end
end
