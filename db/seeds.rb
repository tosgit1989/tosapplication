require "csv"

47.times do |p|
  # pref_numを定義
  if p <= 8 then
    pref_num = "0#{p + 1}"
  else
    pref_num = "#{p + 1}"
  end

  # pref_numと都道府県の関係
  if pref_num.to_i == 1 then prefecture = "hokkaido"
  elsif pref_num.to_i == 2 then prefecture = "aomori"
  elsif pref_num.to_i == 3 then prefecture = "iwate"
  elsif pref_num.to_i == 4 then prefecture = "miyagi"
  elsif pref_num.to_i == 5 then prefecture = "akita"
  elsif pref_num.to_i == 6 then prefecture = "yamagata"
  elsif pref_num.to_i == 7 then prefecture = "fukushima"
  elsif pref_num.to_i == 8 then prefecture = "tochigi"
  elsif pref_num.to_i == 9 then prefecture = "gunma"
  elsif pref_num.to_i == 10 then prefecture = "ibaraki"
  elsif pref_num.to_i == 11 then prefecture = "saitama"
  elsif pref_num.to_i == 12 then prefecture = "chiba"
  elsif pref_num.to_i == 13 then prefecture = "tokyo"
  elsif pref_num.to_i == 14 then prefecture = "kanagawa"
  elsif pref_num.to_i == 15 then prefecture = "yamanashi"
  elsif pref_num.to_i == 16 then prefecture = "nagano"
  elsif pref_num.to_i == 17 then prefecture = "niigata"
  elsif pref_num.to_i == 18 then prefecture = "toyama"
  elsif pref_num.to_i == 19 then prefecture = "ishikawa"
  elsif pref_num.to_i == 20 then prefecture = "fukui"
  elsif pref_num.to_i == 21 then prefecture = "shizuoka"
  elsif pref_num.to_i == 22 then prefecture = "gifu"
  elsif pref_num.to_i == 23 then prefecture = "aichi"
  elsif pref_num.to_i == 24 then prefecture = "mie"
  elsif pref_num.to_i == 25 then prefecture = "shiga"
  elsif pref_num.to_i == 26 then prefecture = "kyoto"
  elsif pref_num.to_i == 27 then prefecture = "osaka"
  elsif pref_num.to_i == 28 then prefecture = "hyogo"
  elsif pref_num.to_i == 29 then prefecture = "nara"
  elsif pref_num.to_i == 30 then prefecture = "wakayama"
  elsif pref_num.to_i == 31 then prefecture = "tottori"
  elsif pref_num.to_i == 32 then prefecture = "shimane"
  elsif pref_num.to_i == 33 then prefecture = "okayama"
  elsif pref_num.to_i == 34 then prefecture = "hiroshima"
  elsif pref_num.to_i == 35 then prefecture = "yamaguchi"
  elsif pref_num.to_i == 36 then prefecture = "tokushima"
  elsif pref_num.to_i == 37 then prefecture = "kagawa"
  elsif pref_num.to_i == 38 then prefecture = "ehime"
  elsif pref_num.to_i == 39 then prefecture = "kochi"
  elsif pref_num.to_i == 40 then prefecture = "fukuoka"
  elsif pref_num.to_i == 41 then prefecture = "saga"
  elsif pref_num.to_i == 42 then prefecture = "nagasaki"
  elsif pref_num.to_i == 43 then prefecture = "kumamoto"
  elsif pref_num.to_i == 44 then prefecture = "ooita"
  elsif pref_num.to_i == 45 then prefecture = "miyazaki"
  elsif pref_num.to_i == 46 then prefecture = "kagoshima"
  elsif pref_num.to_i == 47 then prefecture = "okinawa"
  else prefecture = ""
  end

  # 対象ファイルが存在する場合のみ、ファイルデータをデータベースに入れる
  20.times do |i|
    page_num = i + 1
    if File.exist?("db/scrapingdata/jar_#{pref_num}#{prefecture}_#{area_num}-#{page_num}.csv")
      buildings_csv = CSV.readlines("db/scrapingdata/jar_#{pref_num}#{prefecture}_#{area_num}-#{page_num}.csv")
      buildings_csv.shift # 表の1行目は飛ばす
      buildings_csv.each do |row|
        Building.create(building_name: row[1], image_url: row[2], detail: row[3], fee1: row[4], fee2: row[5], access: row[6], address: row[7])
      end
    end # if File.exist?終了
  end # 20.times do |i|終了
end # 47.times do |p|終了