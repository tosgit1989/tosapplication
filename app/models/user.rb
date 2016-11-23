class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews # ユーザーは自身が投稿したことのある建物の数に応じてレビューを持っている。よって、Userモデルは複数のReviewモデルに所属
  validates :nickname, presence: true # userのnicknameを入力必須に
end
