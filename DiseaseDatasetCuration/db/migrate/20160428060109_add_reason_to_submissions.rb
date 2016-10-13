class AddReasonToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :reason, :integer
  end
end
