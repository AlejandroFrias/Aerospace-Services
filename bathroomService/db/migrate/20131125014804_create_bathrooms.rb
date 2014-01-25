class CreateBathrooms < ActiveRecord::Migration
  def change
    create_table :bathrooms do |t|
      t.decimal :latitude, :precision => 12, :scale => 8, :null => false
      t.decimal :longitude, :precision => 12, :scale => 8, :null => false
      t.decimal :altitude, :precision => 12, :scale => 8, :default => 0
      t.integer :floor
      t.string :sex
      t.string :building

      t.timestamps
    end
  end
end
