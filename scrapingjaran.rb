require 'anemone'
require 'csv'
require 'yaml'



class Scrape

  def main()
    prefectures = YAML.load_file('config/prefectures.yaml')
    for prefecture in prefectures do
      prefecture_code = prefecture[0].to_s
      prefecture_name = prefecture[1]

      if prefecture_code.length < 2
        prefecture_code = '0' + prefecture_code
      end

      puts prefecture_name
      scrape(prefecture_code, prefecture_name)
    end
  end




  def scrape(prefecture, pref_num)
# prefecture = "hokkaido" # 県を入力
# pref_num = "01" # 県に対応した番号を入力
# area_num = "02" # エリア番号を入力

    area_num = 01

# 10.times do |i|のループ
    sleep(1)
    # page_num = i + 1 # ページ番号初期値、iが0から始まるので+1補正
    page_num = 1
    CSV.open("db/scrapingdata/jar_#{pref_num}#{prefecture}_#{area_num}.csv", "w") do |csv|
      csv << ["id", "building_name", "image_url", "detail", "fee1", "fee2", "access", "address"]
      urls = []
      if page_num == 1 then
        urls.push("http://www.jalan.net/#{pref_num}0000/LRG_#{pref_num}#{area_num}00/?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{pref_num}0000&lrgCd=#{pref_num}#{area_num}00&vosFlg=6&idx=0")
      else
        urls.push("http://www.jalan.net/#{pref_num}0000/LRG_#{pref_num}#{area_num}00/page#{i}.html?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{pref_num}0000&lrgCd=#{pref_num}#{area_num}00&vosFlg=6&idx=#{(page_num * 30) - 30}")
      end
      Anemone.crawl(urls, :depth_limit => 0) do |anemone|
        anemone.on_every_page do |page|
          doc = Nokogiri::HTML.parse(page.body.encode("utf-8","shift_jis", :undef => :replace, :replace => "?"))
          page.doc.css('.search-result-cassette').each do |node|
            building_count = page.doc.css('.s16_F60b').inner_text.to_i  # 軒数
            page_max = (building_count + 29) / 30 # 最大ページ番号
            if page_num <= page_max then
              building_name = node.css('.result-body .hotel-detail .hotel-detail-header a').inner_text # ホテル名
              image_url = node.css('.result-body .hotel-picture .main img').attribute('src').value # 画像URL
              detail = node.css('.result-body .hotel-detail .hotel-detail-body td .s12_33').inner_text.gsub(/(\s)/,"") # 詳細
              fee1 = node.css('.result-body .hotel-detail .hotel-detail-header td .s14_00').inner_text.gsub(/(\s)/,"") # 料金
              fee2 = node.css('.result-body .hotel-detail .hotel-detail-header td .s11_66').inner_text.gsub(/(\s)/,"") # 料金一人あたり換算時
              access = node.css('.result-body .hotel-detail .hotel-detail-body td .s11_33').inner_text.gsub(/(\s)/,"") # アクセス
              address = node.css('.result-header tr .s11_66').inner_text # 場所
              puts building_name
              csv << [nil, building_name, image_url, detail, fee1, fee2, access, address]
            else
              exit # 20.times do |i|中止
            end
          end
        end
      end # Anemone.crawl終了
    end
  end # 10.times do |i|終了
end


if __FILE__ == $0
  s = Scrape.new
  s.main
end

