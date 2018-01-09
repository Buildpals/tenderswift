class MakeRemindMeTrueForBoq < ActiveRecord::Migration[5.1]
  def change
    change_column :boqs, :remind_me, :boolean, default: false
  end
end
