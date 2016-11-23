class RankingController < ApplicationController
  layout 'review_site'
  before_action :ranking

  def ranking
    hotel_ids = Review.group(:hotel_id).order('count_hotel_id DESC').limit(5).count(:hotel_id).keys
    @ranking = hotel_ids.map{|id| Hotel.find id}
  end
end
