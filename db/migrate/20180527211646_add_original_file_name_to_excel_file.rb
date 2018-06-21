class AddOriginalFileNameToExcelFile < ActiveRecord::Migration[5.1]
  def change
    add_column :excel_files, :original_file_name, :string
  end
end
