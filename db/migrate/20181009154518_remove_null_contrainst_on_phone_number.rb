class RemoveNullContrainstOnPhoneNumber < ActiveRecord::Migration[5.1]
  def change
    change_column_null :publishers, :phone_number, true
  end
end
