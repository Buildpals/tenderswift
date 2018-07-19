# frozen_string_literal: true

class RemoveListOfRatesFromRequestForTender < ActiveRecord::Migration[5.1]
  def change
    remove_column :request_for_tenders,
                  :list_of_rates,
                  :jsonb,
                  default: { rates: {} }
  end
end
