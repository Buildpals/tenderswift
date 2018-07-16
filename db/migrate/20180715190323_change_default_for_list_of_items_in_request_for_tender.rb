# frozen_string_literal: true

class ChangeDefaultForListOfItemsInRequestForTender < ActiveRecord::Migration[5.1]
  def up
    change_column :request_for_tenders,
                  :list_of_items,
                  :jsonb,
                  default: nil
  end

  def down
    change_column :request_for_tenders,
                  :list_of_items,
                  :jsonb,
                  default: { items: [] }
  end
end
