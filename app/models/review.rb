class Review < ActiveRecord::Base
  belongs_to :hotel # レビューはある特定の建物1つに関してのもの。よって、Reviewモデルは1つのHotelモデルに所属
  belongs_to :user # レビューはある特定のユーザー1人からのもの。よって、Reviewモデルは1つのUserモデルに所属
end
