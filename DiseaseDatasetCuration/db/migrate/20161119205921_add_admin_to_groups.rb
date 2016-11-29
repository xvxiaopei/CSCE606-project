class AddAdminToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :admin_uid, :integer
  end
end
