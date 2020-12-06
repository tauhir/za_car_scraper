class VehiclesSpider < Kimurai::Base
    @name = 'vehicles_spider'
    @engine = :mechanize
  
    def self.process(url)
      @start_urls = [url]
      self.crawl!
    end

    def parse(response, url:, data: {})
      response.xpath("//div[@class='item clearfix vehicle-list__item']").each do |vehicle|
        parse_page(vehicle)
      end
      if next_page = response.at_xpath("//a[@class='pagination__page pagination__nav js-pagination fa fa-right-open-big']")
        return if next_page[:href][-2,2] == "20" # limits the pages to page 20 for testing and dev while I implement the cassettes gem
        request_to :parse, url: absolute_url(next_page[:href], base: url)
      end
    end

    def parse_page(vehicle)
      item = {}
      item[:title]      = vehicle.css('a.vehicle-list__vehicle-name')&.text&.squish
      item[:year]      = vehicle.css('li.vehicle-list__ie7icon-0')&.text&.squish&.delete('^0-9').to_i
      item[:price] = vehicle.css('span.price')&.text&.squish&.delete('^0-9').to_i
      item[:miles]      = vehicle.css('li.vehicle-list__ie7icon-1')&.text&.squish&.delete('^0-9').to_i
      item[:transmission] = vehicle.css('li.vehicle-list__ie7icon-2')&.text&.squish.gsub('Transmission: ', '')
      item[:fuel_type] = vehicle.css('li.vehicle-list__ie7icon-3')&.text&.squish.gsub('Fuel Type: ', '')
      item[:location]  = vehicle.css('i.agent-locality')&.text&.squish.gsub('Location: ', '')
      item[:url] = vehicle.css('a.vehicle-list__view-vehicle')[0][:href]
      Vehicle.where(item).first_or_create
    end
  end
  