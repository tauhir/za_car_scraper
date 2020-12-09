require 'rails_helper'

RSpec.describe VehicleFilterSpider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it "creates Makers and Body_types when scraping" do
    VCR.use_cassette("scraping/vehicle_filter") do
      expect {
      url = 'https://www.cars.co.za/searchVehicle.php?'
      response = VehicleFilterSpider.process(url)
      }.to change{Maker.count && BodyType.count}
    end
  end
end
