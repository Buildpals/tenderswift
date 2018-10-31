class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants do |t|
      t.references :request_for_tender
      t.string :email

      t.timestamps
    end
  end
end
