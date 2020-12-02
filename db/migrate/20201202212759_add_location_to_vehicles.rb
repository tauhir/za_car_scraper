class AddLocationToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :location, :string
  end
end
