class Hotel < ActiveRecord::Base
  has_many :reviews # 建物は自身に関するレビューを複数持っている。よって、Hotelモデルは複数のReviewモデルに所属
  
  def review_rate_average
    self.reviews.average(:rate).round
  end

  def review_count
    self.reviews.count(:id)
  end
end
