class RankingController < ApplicationController
  layout 'review_site'
  before_action :ranking

  def ranking
    building_ids = Review.group(:building_id).order('count_building_id DESC').limit(5).count(:building_id).keys
    @ranking = building_ids.map{|id| Building.find id}
  end
end
