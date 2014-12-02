class AddUpsAndDownsToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :ups, :integer
    add_column :statuses, :downs, :integer
  end
end
