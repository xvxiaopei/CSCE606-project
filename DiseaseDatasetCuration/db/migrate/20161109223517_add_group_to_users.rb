class AddGroupToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :admin_group, :boolean
    remove_column :users, :group, :string
  end
end
