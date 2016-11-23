Rails.application.routes.draw do
    # 以下の2行により投稿画面のルーティングを設定、投稿画面を表示できるように
    get 'hotels/:hotel_id/reviews/new' => 'reviews#new'
    post 'hotels/:hotel_id/reviews' => 'reviews#create'
    get 'api/get_hotels' => 'reviews#new'

    devise_for :users
    resources :users, only: [:show, :edit, :update]
    resources :hotels, only: :show do
    resources :reviews, only: [:new, :create, :destroy, :edit, :update]
    collection do
      get 'search1'
    end
  end
  root 'hotels#index'
end
