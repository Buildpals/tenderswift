class AddRemindMeToBoq < ActiveRecord::Migration[5.1]
  def change
    add_column :boqs, :remind_me, :boolean
  end
end
