class CreateSpaces < ActiveRecord::Migration[8.0]
  def change
    create_table :spaces do |t|
      t.string :name
      t.integer :occupancy
      t.references :library, null: false, foreign_key: true

      t.timestamps
    end
  end
end
