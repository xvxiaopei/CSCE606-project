class AddQuestionToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :admin_addquestion, :boolean
    remove_column :users, :addquestion, :string
  end
end
