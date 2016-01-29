class BuildingsController < RankingController
  def index
    # buildingsテーブルから最新順に建物を２件取得する
    @buildings = Building.order('id ASC').limit(2)
  end

  def show
    # buildingsテーブルから該当するidの建物情報を取得し@buildingの変数へ代入する
    @building = Building.find(params[:id])
  end

  def search
    # 検索フォームのキーワードをあいまい検索して、buildingsテーブルから2件の建物情報を取得する
    @buildings = Building.where('building_name LIKE(?)', "%#{params[:keyword]}%").limit(2)
  end
end
