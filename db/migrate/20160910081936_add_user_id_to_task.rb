class AddUserIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :user_id, :integer, default: nil
  end
end
