class RemoveQuestionTypeFromQuestion < ActiveRecord::Migration[5.1]
  def change
    remove_column :questions, :question_type, :integer
  end
end
