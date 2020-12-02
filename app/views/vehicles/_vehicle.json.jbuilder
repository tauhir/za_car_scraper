json.extract! vehicle, :id, :title, :color, :transmission, :fuel_type, :make, :model, :url, :year, :price, :miles, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
