class CreateWinners < ActiveRecord::Migration[5.1]
  def change
    create_table :winners do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :phone_number
      t.string :auth_token
      t.references :request_for_tender, foreign_key: true
      t.timestamps
    end
  end
end
