class CreateQuantitySurveyorRates < ActiveRecord::Migration[5.1]
  def change
    create_table :quantity_surveyor_rates do |t|
      t.string :sheet_name
      t.float :rate
      t.references :quantity_surveyor, foreign_key: true
      t.references :boq, foreign_key: true
      t.timestamps
    end
  end
end
