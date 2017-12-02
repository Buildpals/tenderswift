class RemoveUnusedDatabaseTables < ActiveRecord::Migration[5.1]
  def change
    drop_table "sections", force: :cascade do |t|
      t.string "name"
      t.bigint "page_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["page_id"], name: "index_sections_on_page_id"
    end

    drop_table "tags", force: :cascade do |t|
      t.string "name"
      t.bigint "boq_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["boq_id"], name: "index_tags_on_boq_id"
    end
  end
end
