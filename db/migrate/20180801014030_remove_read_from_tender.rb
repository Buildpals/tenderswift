# frozen_string_literal: true

class RemoveReadFromTender < ActiveRecord::Migration[5.1]
  def change
    remove_column :tenders, :read, :boolean, default: false, null: false
  end
end
