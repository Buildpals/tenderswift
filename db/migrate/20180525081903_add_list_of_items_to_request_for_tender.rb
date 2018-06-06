# frozen_string_literal: true

class AddListOfItemsToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders,
               :list_of_items,
               :jsonb,
               default: { items: [] }
  end
end
