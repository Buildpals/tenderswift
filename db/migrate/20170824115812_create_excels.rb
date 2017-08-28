class CreateExcels < ActiveRecord::Migration[5.1]
  def change
    create_table :excels do |t|
      t.string :document
      t.references :request
      t.timestamps
    end
  end
end
