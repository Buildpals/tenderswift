class RemovePublishedFromRequestForTender < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders,
                  :published,
                  :boolean,
                  default: false,
                  null: false
  end
end
