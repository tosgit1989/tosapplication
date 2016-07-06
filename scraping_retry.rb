# やり直し用
require 'anemone'
require 'yaml'
require 'mysql'

class Scrape

  def main()
    puts '開始地点について'
    puts '都道府県コード2桁を入力してください。'
    pref_s = gets.to_s
    puts 'エリアコード2桁を入力してください。'
    area_s = gets.to_s
    puts 'ページ番号を入力してください。'
    page_s = gets.to_i
    puts '終了地点について'
    puts '都道府県コード2桁を入力してください。'
    pref_e = gets.to_s
    puts 'エリアコード2桁を入力してください。'
    area_e = gets.to_s
    puts 'ページ番号を入力してください。'
    page_e = gets.to_i

    connection = Mysql::new("localhost", "root", "", "tosapplication_development")

    prefectures = YAML.load_file('config/prefectures.yaml')
    for prefecture in prefectures do
      pref_code = prefecture[0].to_s
      pref_name = prefecture[1]

      if pref_code.length < 2 then
        pref_code = "0#{pref_code}"
      end

      # ----------
      if pref_code.to_i >= pref_s.to_i && pref_code.to_i <= pref_e.to_i then
        puts "都道府県:#{pref_name} 都道府県コード:#{pref_code}"
        scrape(pref_name, pref_code, connection, pref_s, area_s, page_s, pref_e, area_e, page_e)
      else
        puts "都道府県:#{pref_name} 都道府県コード:#{pref_code} skip"
      end
      # ----------

    end
    connection.close
  end

  def scrape(a_pref_name, a_pref_code, a_connection, a_pref_s, a_area_s, a_page_s, a_pref_e, a_area_e, a_page_e)
    98.times do |h|
      if h <= 8 then
        area_code = "0#{h + 1}"
      else
        area_code = "#{h + 1}"
      end

      sleep(1)

      # ----------
      if (a_pref_code.to_i >= a_pref_s.to_i + 1 || area_code.to_i >= a_area_s.to_i) && (a_pref_code.to_i <= a_pref_e.to_i - 1 || area_code.to_i <= a_area_e.to_i) then
        puts "エリアコード:#{area_code}"
        each_area_process(a_pref_name, a_pref_code, a_connection, area_code, a_pref_s, a_area_s, a_page_s, a_pref_e, a_area_e, a_page_e)
      else
        puts "エリアコード:#{area_code} skip"
      end
      # ----------

    end  # 98.times終了
  end # def scrape終了

  def each_area_process(b_pref_name, b_pref_code, b_connection, b_area_code, b_pref_s, b_area_s, b_page_s, b_pref_e, b_area_e, b_page_e)
    10.times do |i|
      page_num = i + 1

      # ----------
      if (b_pref_code.to_i >= b_pref_s.to_i + 1 || b_area_code.to_i >= b_area_s.to_i + 1 || page_num >= b_page_s) && (b_pref_code.to_i <= b_pref_e.to_i - 1 || b_area_code.to_i <= b_area_e.to_i - 1 || page_num <= b_page_e) then
        puts "ページ番号:#{page_num}"
        each_page_process(b_pref_name, b_pref_code, b_connection, b_area_code, page_num)
      else
        puts "ページ番号:#{page_num} skip"
      end
      # ----------

    end # 10.times終了
  end # def each_area_process終了

  def each_page_process(c_pref_name, c_pref_code, c_connection, c_area_code, c_page_num)
    urls = []
    if c_page_num == 1 then
      urls.push("http://www.jalan.net/#{c_pref_code}0000/LRG_#{c_pref_code}#{c_area_code}00/?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{c_pref_code}0000&lrgCd=#{c_pref_code}#{c_area_code}00&vosFlg=6&idx=0")
    else
      urls.push("http://www.jalan.net/#{c_pref_code}0000/LRG_#{c_pref_code}#{c_area_code}00/page#{c_page_num - 1}.html?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{c_pref_code}0000&lrgCd=#{c_pref_code}#{c_area_code}00&vosFlg=6&idx=#{(c_page_num * 30) - 30}")
    end
    Anemone.crawl(urls, :depth_limit => 0) do |anemone|
      anemone.on_every_page do |page|
        doc = Nokogiri::HTML.parse(page.body.encode('utf-8', 'shift_jis', :undef => :replace, :replace => '?'))
        page.doc.css('.search-result-cassette').each do |node|
          building_count = page.doc.css('.s16_F60b').inner_text.to_i  # 軒数
          page_max = (building_count + 29) / 30 # 最大ページ番号
          if c_page_num <= page_max then
            building_name = node.css('.result-body .hotel-detail .hotel-detail-header a').inner_text.gsub(/'/, "’") # ホテル名
            begin image_url = node.css('.result-body .hotel-picture .main img').attribute('src').value rescue image_url = "" end # 画像URL
            detail = node.css('.result-body .hotel-detail .hotel-detail-body td .s12_33').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # 詳細
            fee1 = node.css('.result-body .hotel-detail .hotel-detail-header td .s14_00').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # 料金
            fee2 = node.css('.result-body .hotel-detail .hotel-detail-header td .s11_66').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # 料金一人あたり換算時
            access = node.css('.result-body .hotel-detail .hotel-detail-body td .s11_33').inner_text.gsub(/(\s)/,"").gsub(/'/, "’") # アクセス
            address = node.css('.result-header tr .s11_66').inner_text.gsub(/'/, "’") # 場所
            prefareapage = "#{c_pref_code}#{c_area_code}0#{c_page_num.to_s}" # 都道府県コードエリアコードページ番号

            statement = c_connection.prepare("
                  INSERT INTO buildings (
                    building_name,
                    image_url,
                    detail,
                    fee1,
                    fee2,
                    access,
                    address,
                    prefareapage
                  )
                  VALUES (
                    '#{building_name}',
                    '#{image_url}',
                    '#{detail}',
                    '#{fee1}',
                    '#{fee2}',
                    '#{access}',
                    '#{address}',
                    '#{prefareapage}'
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
  end # def each_page_process終了
end # class Scrape終了


if __FILE__ == $0
  s = Scrape.new
  s.main
end