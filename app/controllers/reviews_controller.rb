class ReviewsController < RankingController
  before_action :authenticate_user!, only: :new # ログインしていない時にレビューを投稿しようとすると、ログイン画面にリダイレクト

  def new # レビュー投稿画面
    @building = Building.find(params[:building_id])
    @review = Review.new
  end

  def create # レビュー投稿機能
    Review.create(create_params) # reviews_controller.rbのcreateアクションでレビューデータを受け取り、データベースのReviewsテーブルに保存
    redirect_to controller: :buildings, action: :index # トップページにリダイレクトする
  end

  def edit # レビュー編集機能
    @review = Review.find(params[:id])
    @building = @review.building
  end

  def update # レビュー更新機能
    @review = Review.find(params[:id])
    @building = @review.building
    @review.update(update_params)
  end

  private
  def create_params
    params.require(:review).permit(:rate, :review).merge(building_id: params[:building_id], user_id: current_user.id)
  end

  def update_params
    params.require(:review).permit(:rate, :review).merge(building_id: params[:building_id], user_id: current_user.id)
  end
end
