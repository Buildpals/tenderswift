class AddPhoneNumberColumnToPartcipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :phone_number, :string
  end
end
