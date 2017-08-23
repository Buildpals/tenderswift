class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants do |t|
      t.string :email, null: false
      t.string :phone_number, limit: 10
      t.timestamps
    end
  end
end
