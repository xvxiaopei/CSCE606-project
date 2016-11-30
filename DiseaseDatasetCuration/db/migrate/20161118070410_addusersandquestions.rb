class Addusersandquestions < ActiveRecord::Migration
  def change
    add_index "addquestions_users", ["addquestion_id"], name: "index_addquestions_users_on_addquestion_id"
    add_index "addquestions_users", ["user_id"], name: "index_addquestions_users_on_user_id"
  end
end
