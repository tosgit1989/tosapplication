class AddNicknameToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :nickname, :string
  end
end
