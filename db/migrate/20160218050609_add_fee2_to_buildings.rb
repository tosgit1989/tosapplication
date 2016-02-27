class AddFee2ToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :fee2, :string
  end
end
