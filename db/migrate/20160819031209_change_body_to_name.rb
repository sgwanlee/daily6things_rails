class ChangeBodyToName < ActiveRecord::Migration
  def change
    rename_column :tasks, :body, :name
  end
end
