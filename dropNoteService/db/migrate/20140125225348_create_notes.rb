class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :tag, :default => "note"
      t.string :title
      t.text :body
      t.decimal :latitude, :precision => 12, :scale => 8, :null => false
      t.decimal :longitude, :precision => 12, :scale => 8, :null => false
      t.decimal :altitude, :precision => 12, :scale => 8, :default => 0

      t.timestamps
    end
  end
end
