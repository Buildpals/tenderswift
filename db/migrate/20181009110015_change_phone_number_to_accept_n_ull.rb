class ChangePhoneNumberToAcceptNUll < ActiveRecord::Migration[5.1]
  def change
    change_column :publishers, :phone_number, :string, null: true
  end
end
