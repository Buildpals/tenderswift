# frozen_string_literal: true

class AddListOfRatesToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders,
               :list_of_rates,
               :jsonb,
               default: { rates: {} }
  end
end
