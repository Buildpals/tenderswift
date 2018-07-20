class ChangeDefaultForListOfItems < ActiveRecord::Migration[5.1]
  def up
    change_column :request_for_tenders,
                  :list_of_items,
                  :jsonb,
                  default: { 'Sheets' => {}, 'SheetNames' => [] }
  end

  def down
    change_column :request_for_tenders,
                  :list_of_items,
                  :jsonb,
                  default: nil
  end
end
