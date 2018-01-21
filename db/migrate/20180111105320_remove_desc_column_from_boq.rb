class RemoveDescColumnFromBoq < ActiveRecord::Migration[5.1]
  def change
    remove_column :boqs, :desc_column
  end
end
