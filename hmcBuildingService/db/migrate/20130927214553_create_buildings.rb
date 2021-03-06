class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.decimal :latitude,    :precision => 12, :scale => 8, :null => false
      t.decimal :longitude,   :precision => 12, :scale => 8, :null => false
      t.decimal :altitude,    :precision => 12, :scale => 8, :default => 0
      t.string  :name,        :null => false
      t.text    :description, :null => false
      t.string  :code,        :default => "NONE"

      t.timestamps
    end
  end
end
