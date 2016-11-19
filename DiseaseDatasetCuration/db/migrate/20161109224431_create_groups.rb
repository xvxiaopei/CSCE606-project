class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :group_level, default: 'graduate'
      t.timestamps null: false
    end
  end
end
