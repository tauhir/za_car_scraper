require 'rails_helper'

RSpec.describe VehiclesSpider,:vcr, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it "creates vehicles when scraping" do
    expect {
      visit(root_path)
      click_on "Scrape"
    }.to change{Vehicle.count}
  end
end
