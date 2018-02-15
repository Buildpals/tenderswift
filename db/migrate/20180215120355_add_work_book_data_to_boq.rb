class AddWorkBookDataToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :workbook_data, :text
  end
end
