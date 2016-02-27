class Scraping
  def self.hotel_urls
    agent = Mechanize.new
    links = []

    next_url = "/now/"

    while true do
      current_page = agent.get('http://www.xxx.jp' + next_url) # URLを入れよう
      elements = current_page.search('.m_unit h3 a')
      elements.each do |ele|
        links << ele.get_attribute('href')
      end

      next_link = current_page.at('.next_page')
      next_url = next_link.get_attribute('href')
      break unless next_url
    end 

    links.each do |link|
      get_building('http://www.jp' + link) # URLを入れよう
    end
  end

  def self.get_building(link)
    agent = Mechanize.new
    page = agent.get(link)
    building_name = page.at('.hotel-name a').inner_text
    image_url = page.at('.hotel-picture .main a')[:src] if page.at('.hotel-picture .main a')
    detail = page.at('.s12_33').inner_text if page.at('.s12_33')
    fee1 = page.at('.s14_00 fb').inner_text if page.at('.s14_00 fb') # 一人あたりの宿泊料とは限らない(最安値)
    fee2 = page.at('.s11_66').inner_text if page.at('.s11_66') # 一人あたりの宿泊料(最安値)
    access = page.at('.s11_33 hotel-access').inner_text if page.at('.s11_33 hotel-access')
    address = page.at('tr .s11_66').inner_text if page.at('tr .s11_66')

    building = Building.where(building_name: building_name, image_url: image_url).first_or_initialize
    building.detail = detail
    building.fee1 = fee1
    building.fee2 = fee2
    building.access = access
    building.address = address
    building.save
  end
end