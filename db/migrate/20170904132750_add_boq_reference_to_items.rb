class AddBoqReferenceToItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :items, :boq
  end
end
