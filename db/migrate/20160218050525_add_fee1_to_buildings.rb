class AddFee1ToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :fee1, :string
  end
end
