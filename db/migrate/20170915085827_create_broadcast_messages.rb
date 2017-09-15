class CreateBroadcastMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :broadcast_messages do |t|
      t.text :content
      t.references :chatroom, foreign_key: true
      t.timestamps
    end
  end
end
