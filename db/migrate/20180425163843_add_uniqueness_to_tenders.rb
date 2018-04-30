# frozen_string_literal: true

class AddUniquenessToTenders < ActiveRecord::Migration[5.1]
  def change
    add_index :tenders, %i[request_for_tender_id contractor_id], unique: true
  end
end
