class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text     :all_data
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer :count, default: 0
      t.integer :num_correct, default: 0
      t.float :accuracy, default: 0.0
      t.integer  :user_id, default: 0

      t.timestamps null: false
    end
#    add_index :submissions, [:user_id, :created_at]
  end
end
