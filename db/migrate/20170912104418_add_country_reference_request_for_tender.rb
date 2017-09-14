class AddCountryReferenceRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_reference :request_for_tenders, :country
  end
end
