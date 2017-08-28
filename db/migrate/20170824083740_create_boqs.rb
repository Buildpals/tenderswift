class CreateBoqs < ActiveRecord::Migration[5.1]
  def change
    create_table :boqs do |t|
      t.string :name
      t.references :request
      t.timestamps
    end
  end
end
