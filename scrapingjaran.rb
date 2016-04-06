require 'anemone'
require 'csv'
require 'yaml'
require 'mysql'

class Scrape

  def main()
    connection = Mysql::new("localhost", "root", "", "tosapplication_development")

    prefectures = YAML.load_file('config/prefectures.yaml')
    for prefecture in prefectures do
      prefecture_code = prefecture[0].to_s
      prefecture_name = prefecture[1]

      if prefecture_code.length < 2 then
        prefecture_code = '0' + prefecture_code
      end

      puts prefecture_code
      puts prefecture_name
      scrape(prefecture_name, prefecture_code, connection)
    end
    connection.close
  end

  def scrape(prefecture, pref_num, connection)
    98.times do |h|
      if h <= 8 then
        area_num = "0#{h + 1}"
      else
        area_num = "#{h + 1}"
      end

      sleep(1)

      10.times do |i|
        page_num = i + 1
        urls = []
        if page_num == 1 then
          urls.push("http://www.jalan.net/#{pref_num}0000/LRG_#{pref_num}#{area_num}00/?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{pref_num}0000&lrgCd=#{pref_num}#{area_num}00&vosFlg=6&idx=0")
        else
          urls.push("http://www.jalan.net/#{pref_num}0000/LRG_#{pref_num}#{area_num}00/page#{i}.html?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{pref_num}0000&lrgCd=#{pref_num}#{area_num}00&vosFlg=6&idx=#{(page_num * 30) - 30}")
        end
        Anemone.crawl(urls, :depth_limit => 0) do |anemone|
          anemone.on_every_page do |page|
            doc = Nokogiri::HTML.parse(page.body.encode('utf-8', 'shift_jis', :undef => :replace, :replace => '?'))
            page.doc.css('.search-result-cassette').each do |node|
              building_count = page.doc.css('.s16_F60b').inner_text.to_i  # 軒数
              page_max = (building_count + 29) / 30 # 最大ページ番号
              if page_num <= page_max then
                a_building_name = node.css('.result-body .hotel-detail .hotel-detail-header a').inner_text # ホテル名
                begin a_image_url = node.css('.result-body .hotel-picture .main img').attribute('src').value rescue a_image_url = "#{pref_num}-#{area_num}-#{page_num}-err" end # 画像URL
                a_detail = node.css('.result-body .hotel-detail .hotel-detail-body td .s12_33').inner_text.gsub(/(\s)/,"") # 詳細
                a_fee1 = node.css('.result-body .hotel-detail .hotel-detail-header td .s14_00').inner_text.gsub(/(\s)/,"") # 料金
                a_fee2 = node.css('.result-body .hotel-detail .hotel-detail-header td .s11_66').inner_text.gsub(/(\s)/,"") # 料金一人あたり換算時
                a_access = node.css('.result-body .hotel-detail .hotel-detail-body td .s11_33').inner_text.gsub(/(\s)/,"") # アクセス
                a_address = node.css('.result-header tr .s11_66').inner_text # 場所

                statement = connection.prepare("
                  INSERT INTO buildings (
                    building_name,
                    image_url,
                    detail,
                    fee1,
                    fee2,
                    access,
                    address
                  )
                  VALUES (
                    '#{a_building_name}',
                    '#{a_image_url}',
                    '#{a_detail}',
                    '#{a_fee1}',
                    '#{a_fee2}',
                    '#{a_access}',
                    '#{a_address}'
                  )
                ")

                puts statement

                begin
                  result = statement.execute()
                  # result.each do |tuple|
                  #   puts tuple[0]  # value1 の値
                  #   puts tuple[1]  # value2 の値
                  # end
                ensure
                  statement.close
                end
              end
            end
          end
        end # Anemone.crawl終了
      end # 10.times終了
    end  # 98.times終了
  end # def scrape終了
end # class Scrape終了


if __FILE__ == $0
  s = Scrape.new
  s.main
end