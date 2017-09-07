class AddQsReferenceToRequestForTenders < ActiveRecord::Migration[5.1]
  def change
    add_reference :request_for_tenders, :quantity_surveyor, index: true
  end
end
