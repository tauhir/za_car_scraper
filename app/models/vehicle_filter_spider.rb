class VehicleFilterSpider < Kimurai::Base
    @name = 'vehicle_filter_spider'
    @engine = :mechanize
  
    def self.process(url)
      @start_urls = [url]
      self.crawl!
    end

    def parse(response, url:, data: {})
      browser.click_link "Make & Model"
      response.xpath("//div[@class='picker-list picker-tree search-box__picker-list']").each do |make|
        byebug
          request_to :parse_individual, url: absolute_url(vehicle.css('a.vehicle-list__view-vehicle')[0][:href], base: url)
      end
      if next_page = response.at_xpath("//a[@class='pagination__page pagination__nav js-pagination fa fa-right-open-big']")
        return if next_page[:href][-1] == "3" # limits the pages to page 3 for testing and dev while I implement the cassettes gem
        request_to :parse, url: absolute_url(next_page[:href], base: url)
      end
    end
end