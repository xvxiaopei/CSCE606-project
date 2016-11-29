class CreateAddquestions < ActiveRecord::Migration
  def change
    create_table :addquestions do |t|
      t.text :content
      t.string :answer

      t.timestamps null: false
    end
  end
end
