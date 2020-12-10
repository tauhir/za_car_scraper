class AddBodyTypeToVehicles < ActiveRecord::Migration[6.0]
    def change
      add_reference :vehicles, :body_type, foreign_key: true
    end
end
  
