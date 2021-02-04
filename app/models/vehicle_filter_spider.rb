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
    body_list_start = names_list.find_index("Body Types")+1
    body_list_end = names_list[body_list_start,names_list.size].each_with_index do |string,index| break index if  x[0,2] == "R " end # need to do this because its destined to fail if I use fixed values as before. 
    # the end of the body_list is a number that is the cheapest car on the market which can change
    body_type_list = x[body_list_start,(body_list_end - 2)] 
    
    browser.find("//div[@id='make_model_button']").click
    makes_list.each do |maker|

      Maker.create(
        name: maker.text,

        cars_coza: browser.find(maker.path).first(".//a")[:href]
      )
    end
    body_type_list.each do |body|

      BodyType.create(
        name: body.text,

        cars_coza: browser.find(body.path).first(".//a")[:href]
      )
    end
 
  end
end