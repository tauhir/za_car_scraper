class AddImgUrlToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicles, :img_url, :string
  end
end
