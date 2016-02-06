Rails.application.routes.draw do
    # 以下の2行により投稿画面のルーティングを設定、投稿画面を表示できるように
    get 'buildings/:building_id/reviews/new' => 'reviews#new'
    post 'buildings/:building_id/reviews' => 'reviews#create'
    
    devise_for :users
    resources :users, only: :show
    resources :buildings, only: :show do
    resources :reviews, only: [:new, :create]
    collection do
      get 'search'
    end
  end
  root 'buildings#index'
end
