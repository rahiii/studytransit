class RemoveOccupancyFromSpaces < ActiveRecord::Migration[8.0]
  def change
    remove_column :spaces, :occupancy, :integer
  end
end
