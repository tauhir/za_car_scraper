class AddMakerToVehicles < ActiveRecord::Migration[6.0]
    def change
      add_reference :vehicles, :maker, foreign_key: true
    end
end
  
