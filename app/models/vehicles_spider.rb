class VehiclesSpider < Kimurai::Base
    @name = 'vehicles_spider'
    @engine = :mechanize

    def self.process(filter)
      @name = filter # using the name field to pass this on because I'm not sure whats going on in crawl method
      
      @start_urls = [filter.cars_coza]
      self.crawl!
      
    end
    
    def parse(response, url:, data: {})
    #logger.progname.id
      response.xpath("//div[@class='item clearfix vehicle-list__item']").each do |vehicle|
          request_to :parse_individual, url: absolute_url(vehicle.css('a.vehicle-list__view-vehicle')[0][:href], base: url)
      end
      if next_page = response.at_xpath("//a[@class='pagination__page pagination__nav js-pagination fa fa-right-open-big']")
        return if next_page[:href][-1] == "3" # limits the pages to page 3 for testing and dev while I implement the cassettes gem
        request_to :parse, url: absolute_url(next_page[:href], base: url)
      end
    end

    def parse_individual(response, url:, data: {}) 
      response.xpath("//div[@class='box vehicledetails']").each do |vehicle|
        parse_page(vehicle, url)
      end
    end

    def parse_page(vehicle,url)
      item = {}
      item[:title]      = vehicle.css('h3.vehicle-view__description-heading')&.text&.squish
      item[:price] = vehicle.css('div.vehicle-view__price')&.text&.squish&.delete('^0-9').to_i
      # data is stored in tables so we need to extract it
      table_items = []
      table = vehicle.at('.vehicle-view__section')
      table.search('tr').each do |row|
        row.search('td').each do |attrib| 
          table_items.append(attrib.children.text)
        end
      end
      item[:year]      = get_next_in_array(table_items, "Year").squish&.delete('^0-9').to_i
      item[:miles]      = get_next_in_array(table_items, "Mileage").squish&.delete('^0-9').to_i
      item[:transmission] = get_next_in_array(table_items, "Transmission")&.squish
      item[:fuel_type] = get_next_in_array(table_items, "Fuel Type")&.squish
      item[:location]  = get_next_in_array(table_items, "Area")&.squish
      item[:color]  = get_next_in_array(table_items, "Colour")&.squish
      # item[:condition]  = get_next_in_array(table_items, "Condition")&.squish TODO
      # item[:reference]  = get_next_in_array(table_items, "Reference")&.squish
      # item[:options]  = get_next_in_array(table_items, "Options")&.squish
      item[:url] = url
      vehicle = Vehicle.where(item).first_or_create
      vehicle[:body_type_id] = logger.progname.id if logger.progname.class == BodyType.new.class
      vehicle[:body_type_id] = logger.progname.id if logger.progname.class == Maker.new.class
      vehicle.save
    end
  end

  def get_next_in_array(array,value)
    index = array.find_index(value)
    array[index+1]
  end

  