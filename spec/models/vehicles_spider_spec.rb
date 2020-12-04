require 'rails_helper'

RSpec.describe VehiclesSpider, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it "creates vehicles when scraping" do
    Capybara.threadsafe = true
    expect {
      visit(root_path)
      click_on "Scrape"
    }.to change{Vehicle.count}
  end
end
