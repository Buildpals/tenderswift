class AddTenderInstructionsToRequestForTender < ActiveRecord::Migration[5.1]
  def change
    add_column :request_for_tenders, :tender_instructions, :text
  end
end
