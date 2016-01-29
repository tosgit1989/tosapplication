class AddBuildingIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :building_id, :integer
  end
end
