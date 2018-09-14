class ChangeRatingToScoreInTenders < ActiveRecord::Migration[5.1]
  def change
    rename_column :tenders, :rating, :score
  end
end
