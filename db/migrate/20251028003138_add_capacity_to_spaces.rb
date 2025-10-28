class AddCapacityToSpaces < ActiveRecord::Migration[8.0]
  def change
    add_column :spaces, :capacity, :integer
  end
end
