class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :disease, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :is_related

      t.timestamps null: false
    end
    add_index :submissions, [:user_id, :created_at]
  end
end
