class Building < ActiveRecord::Base
  has_many :reviews # 建物は自身に関するレビューを複数持っている。よって、Buildingモデルは複数のReviewモデルに所属
end
