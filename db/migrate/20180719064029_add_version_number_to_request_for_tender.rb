# frozen_string_literal: true

class AddVersionNumberToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders,
               :version_number,
               :bigint,
               null: false,
               default: 0
  end
end
