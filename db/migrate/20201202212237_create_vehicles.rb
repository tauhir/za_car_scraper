class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.string :title
      t.string :color
      t.string :transmission
      t.string :fuel_type
      t.string :make
      t.string :model
      t.string :url
      t.integer :year
      t.integer :price
      t.integer :miles

      t.timestamps
    end
  end
end
