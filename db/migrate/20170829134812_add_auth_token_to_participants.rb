class AddAuthTokenToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :auth_token, :string
    add_index :participants, :auth_token, unique: true
  end
end
