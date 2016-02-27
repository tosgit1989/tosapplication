class RemoveFeeFromBuildings < ActiveRecord::Migration
  def change
    remove_column :buildings, :fee, :string
  end
end
