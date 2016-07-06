# scraping.rbよりはリファクタリング箇所が少ない
require 'anemone'
require 'yaml'
require 'mysql'

class Scrape

  def main()
    connection = Mysql::new("localhost", "root", "", "tosapplication_development")

    prefectures = YAML.load_file('config/prefectures.yaml')
    for prefecture in prefectures do
      pref_code = prefecture[0].to_s
      pref_name = prefecture[1]

      if pref_code.length < 2 then
        pref_code = "0#{pref_code}"
      end

      puts "都道府県:#{pref_name} 都道府県コード:#{pref_code}"
      scrape(pref_name, pref_code, connection)
    end
    connection.close
  end

  def scrape(a_pref_name, a_pref_code, a_connection)
    98.times do |h|
      if h <= 8 then
        area_code = "0#{h + 1}"
      else
        area_code = "#{h + 1}"
      end

      sleep(1)

      puts "エリアコード:#{area_code}"

      10.times do |i|
        page_num = i + 1
        puts "ページ番号:#{page_num}"
        urls = []
        if page_num == 1 then
          urls.push("http://www.jalan.net/#{a_pref_code}0000/LRG_#{a_pref_code}#{area_code}00/?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{a_pref_code}0000&lrgCd=#{a_pref_code}#{area_code}00&vosFlg=6&idx=0")
        else
          urls.push("http://www.jalan.net/#{a_pref_code}0000/LRG_#{a_pref_code}#{area_code}00/page#{i}.html?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{a_pref_code}0000&lrgCd=#{a_pref_code}#{area_code}00&vosFlg=6&idx=#{(page_num * 30) - 30}")
        end
        Anemone.crawl(urls, :depth_limit => 0) do |anemone|
          anemone.on_every_page do |page|
            doc = Nokogiri::HTML.parse(page.body.encode('utf-8', 'shift_jis', :undef => :replace, :replace => '?'))
            page.doc.css('.search-result-cassette').each do |node|
              building_count = page.doc.css('.s16_F60b').inner_text.to_i  # 軒数
              page_max = (building_count + 29) / 30 # 最大ページ番号
              if page_num <= page_max then
                building_name = node.css('.result-body .hotel-detail .hotel-detail-header a').inner_text.gsub(/'/, "’") # ホテル名
                begin image_url = node.css('.result-body .hotel-picture .main img').attribute('src').value rescue image_url = "" end # 画像URL
                detail = node.css('.result-body .hotel-detail .hotel-detail-body td .s12_33').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # 詳細
                fee1 = node.css('.result-body .hotel-detail .hotel-detail-header td .s14_00').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # 料金
                fee2 = node.css('.result-body .hotel-detail .hotel-detail-header td .s11_66').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # 料金一人あたり換算時
                access = node.css('.result-body .hotel-detail .hotel-detail-body td .s11_33').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # アクセス
                address = node.css('.result-header tr .s11_66').inner_text.gsub(/'/, "’") # 場所

                statement = a_connection.prepare("
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
                    '#{building_name}',
                    '#{image_url}',
                    '#{detail}',
                    '#{fee1}',
                    '#{fee2}',
                    '#{access}',
                    '#{address}'
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