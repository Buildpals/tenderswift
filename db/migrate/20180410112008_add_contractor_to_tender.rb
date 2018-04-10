class AddContractorToTender < ActiveRecord::Migration[5.1]
  def change
    add_reference :tenders, :contractor, foreign_key: true
  end
end
