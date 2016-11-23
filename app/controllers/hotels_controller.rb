class HotelsController < RankingController
  before_action :authenticate_user!, only: :search # ログインしていない時にレビューを投稿しようとすると、ログイン画面にリダイレクト
  def index
    # hotelsテーブルから最新順に建物を20件取得する
    @hotels = Hotel.order('id ASC').limit(20)
  end

  def show
    # hotelsテーブルから該当するidの建物情報を取得し@hotelの変数へ代入する
    @hotel = Hotel.find(params[:id])
  end

  def search1
    # 検索フォームのキーワードをあいまい検索して、hotelsテーブルから建物情報を取得する
    @hotels_a = Hotel.where('address LIKE(?)', "%#{params[:keypref]}%").where('hotel_name LIKE(?)', "%#{params[:keyword]}%").where('detail LIKE(?)', "%#{params[:keydeta]}%")
    @hotels_b = @hotels_a.page(params[:page]).per(20)
    
  end

end
