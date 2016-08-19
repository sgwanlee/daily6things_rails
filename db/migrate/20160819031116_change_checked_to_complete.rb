class ChangeCheckedToComplete < ActiveRecord::Migration
  def change
    rename_column :tasks, :checked, :complete
  end
end
