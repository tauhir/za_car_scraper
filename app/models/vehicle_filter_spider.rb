class VehicleFilterSpider < Kimurai::Base
  @name = 'vehicle_filter_spider'
  @engine = :selenium_chrome
  # this should run sporadically and update


  def self.process(url)
    @start_urls = [url]
    self.crawl!
  end

  def parse(response, url:, data: {})
    list = browser.find("//div[@id='make_model_button']").all("//li[@class='item']")
    x = list[0].all('//a').first.all('//span')
    names_list = x.map{|value| value.text}
    makes_list = x[names_list.find_index("Makes")+1,(names_list.find_index("Body Types")-names_list.find_index("Makes"))]
    body_type_list = x[names_list.find_index("Body Types")+1,(names_list.find_index("R 20 000") - names_list.find_index("Body Types"))]
    File.open("makers_list.yml", "w"){ |o| o.write(makes_list.to_yaml)  } # import current file and compare 
    File.open("body_type_list.yml", "w"){ |o| o.write(body_type_list.to_yaml)  }
  end
end