class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :building_name
      t.text :image_url
      t.text :detail
      t.string :fee
      t.text :access
      t.text :address
      t.timestamps
    end
  end
end
