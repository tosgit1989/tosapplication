require 'anemone'
require 'csv'

prefecture = "chiba"
pref_num = "12"
area_num = "14"
i = 1

while i <= 100 do
  CSV.open("jar_#{prefecture}_#{area_num}-#{i}.csv", "w") do |csv|
  urls = []
  if i == 1 then
    urls.push("http://www.jalan.net/#{pref_num}0000/LRG_#{pref_num}#{area_num}00/?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{pref_num}0000&lrgCd=#{pref_num}#{area_num}00&vosFlg=6&idx=0")
  else
    urls.push("http://www.jalan.net/#{pref_num}0000/LRG_#{pref_num}#{area_num}00/page#{i}.html?screenId=UWW1402&distCd=&photo=&activeSort=0&mvTabFlg=&rootCd=&stayYear=&stayMonth=&stayDay=&stayCount=&roomCount=&dateUndecided=&adultNum=&roomCrack=200000&kenCd=#{pref_num}0000&lrgCd=#{pref_num}#{area_num}00&vosFlg=6&idx=#{(i * 30) - 30}")
  end
  Anemone.crawl(urls, :depth_limit => 0) do |anemone|
    anemone.on_every_page do |page|
      doc = Nokogiri::HTML.parse(page.body.encode("utf-8","shift_jis", :undef => :replace, :replace => "?"))
      page.doc.xpath("//div[@class='search-result-cassette']").each do |node|
        kensuu = page.doc.css('.s16_F60b').inner_text.to_i  # 軒数
        peezisuu = (kensuu + 29) / 30 # 合計ページ数
        if i <= peezisuu then
          building_name = node.css('.result-body .hotel-detail .hotel-detail-header a').inner_text # ホテル名
          image_url = node.css('.result-body .hotel-picture .main a').attribute('href').value # 画像URL
          detail = node.css('.result-body .hotel-detail .hotel-detail-body td .s12_33').inner_text # 詳細
          fee1 = node.css('.result-body .hotel-detail .hotel-detail-header td .s14_00').inner_text # 料金
          fee2 = node.css('.result-body .hotel-detail .hotel-detail-header td .s11_66').inner_text # 料金一人あたり換算時
          access = node.css('.result-body .hotel-detail .hotel-detail-body td .s11_33').inner_text # アクセス
          address = node.css('.result-header tr .s11_66').inner_text # 場所
          csv << [nil, building_name, image_url, detail, fee1, fee2, access, address]
        else
          exit
        end
      end
    end
  end
  end
  i = i + 1
end

## errors
# saitama_kumagaya
# saitama_iinou
# ibaraki_jousou
# gunma_kusatsu
# gunma_mizukami
# gunma_numata
# tochigi_utsunomiya
# tochigi_shiohara
# tochigi_magasira
# shizuoka_itou
# mie_tsu
# nara_nara
# hyogo_kaminabe
# kyoto_kawaracho
# shiga_kosei
# okayama_kurasiki
# hiroshima_atsuhara
# fukuoka_kurume
# nagasaki_goshimarettou
# miyazaki_miyazaki
# kagoshima_tarumizu
# aomori_shimokita
# fukushima_iwaki
# hokkaido_toyono
# okinawa_motobe
# okinawa_okinawashi
# okinawa_nishikaigan
# yamanashi_yatsugatake
# nagano_siroma
# niigata_joetsu
# niigata_minamiuoyama
# ehime_imazi
# toyama_toyama





