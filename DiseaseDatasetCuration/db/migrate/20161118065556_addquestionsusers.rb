class Addquestionsusers < ActiveRecord::Migration
  def change
    create_table "addquestions_users", id: false, force: :cascade do |t|
      t.integer "user_id"
      t.integer "addquestion_id"
      t.belongs_to :user, index: true
      t.belongs_to :addquestion, index: true
    end
  end
end
