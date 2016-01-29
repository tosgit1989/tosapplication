class RemoveProductIdFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :product_id, :integer
  end
end
