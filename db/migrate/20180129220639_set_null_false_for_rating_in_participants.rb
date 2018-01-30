class SetNullFalseForRatingInParticipants < ActiveRecord::Migration[5.1]
  def change
    change_column_null :participants, :rating, false
  end
end
