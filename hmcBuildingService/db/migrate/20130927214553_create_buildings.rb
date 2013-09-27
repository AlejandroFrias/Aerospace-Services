class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.decimal :latitude, :precision => 6, :scale => 4
      t.decimal :longitude, :precision => 6, :scale => 4
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
