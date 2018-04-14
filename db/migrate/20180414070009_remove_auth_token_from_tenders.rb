class RemoveAuthTokenFromTenders < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenders, :auth_token, :token
  end
end
