require 'rails_helper'

RSpec.describe VehiclesSpider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  before(:all) do
    url = 'https://www.cars.co.za/searchVehicle.php?'
    response = VehicleFilterSpider.process(url)
  end

  it "creates vehicles when scraping" do
    expect {
      visit(root_path)
      click_on "Scrape"
    }.to change{Vehicle.count}
  end
end
