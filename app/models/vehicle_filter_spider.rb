class VehicleFilterSpider < Kimurai::Base
  @name = 'vehicle_filter_spider'
  @engine = :selenium_chrome # https://www.botreetechnologies.com/blog/how-to-do-web-scraping-of-a-static-or-dynamic-website-with-ruby-on-rails/ - setup chromedriver
  # this should run sporadically and update


  def self.process(url)
    @start_urls = [url]
    self.crawl!
  end
 
  def parse(response, url:, data: {})
    
    list = browser.find("//div[@id='make_model_button']").all("//li[@class='item']")
    x = list[0].all('//a').first.all('//span')
    names_list = x.map{|value| value.text}
    makes_list = x[names_list.find_index("Makes")+1,(names_list.find_index("Body Types")-names_list.find_index("Makes")-1)]
    body_type_list = x[names_list.find_index("Body Types")+1,(names_list.find_index("R 20 000") - names_list.find_index("Body Types")-1)]
    browser.find("//div[@id='make_model_button']").click
    makes_list.each do |maker|

      Maker.create(
        name: maker.text,

        cars_coza: browser.find(maker.path).first(".//a")[:href]
      )
    end
    byebug
    File.open("makers_list.yml", "w"){ |o| o.write(makes_list.to_yaml)  } # import current file and compare 
    File.open("body_type_list.yml", "w"){ |o| o.write(body_type_list.to_yaml)  }
    #I'm going to get the URL for each make by clicking the button instead of doing the above.
    # I'm going to create a table for makes and a table for body_types instead
    # name (should be unique), url for site A, url for site B
    # currently I'm getting the span and not the a element.  path="/HTML/BODY[1]/DIV[2]/DIV[1]/DIV[1]/DIV[1]/DIV[1]/FORM[1]/DIV[2]/DIV[3]/A[1]">
  end
end