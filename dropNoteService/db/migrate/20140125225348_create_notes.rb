class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :tags, :default => "note"
      t.string :title, :null => false
      t.string :user, :default => "public"
      t.string :password, :default => "password"
      t.text :body, :null => false
      t.decimal :latitude, :precision => 12, :scale => 8, :null => false
      t.decimal :longitude, :precision => 12, :scale => 8, :null => false
      t.decimal :altitude, :precision => 12, :scale => 8, :default => 0

      t.timestamps
    end
  end
end
