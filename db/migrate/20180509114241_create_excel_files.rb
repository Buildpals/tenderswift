class CreateExcelFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :excel_files do |t|
      t.string :document
      t.references :request_for_tender
      t.timestamps
    end
  end
end
