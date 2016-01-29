class ReviewsController < RankingController
  def new
    @building = Building.find(params[:building_id])
    @review = Review.new
  end

  def create
    # reviews_controller.rbのcreateアクションでレビューデータを受け取り、データベースのReviewsテーブルに保存
    Review.create(create_params)
    # トップページにリダイレクトする
    redirect_to controller: :buildings, action: :index
  end

  private
  def create_params
    params.require(:review).permit(:rate, :review).merge(building_id: params[:building_id])
  end
end
