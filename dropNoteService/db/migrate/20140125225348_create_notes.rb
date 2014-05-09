class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.belongs_to :user
      t.integer :user_id
      t.string :name, :null => false
      t.text :body, :null => false
      t.boolean :privacy_on, :default => false
      t.decimal :latitude, :precision => 12, :scale => 8, :null => false
      t.decimal :longitude, :precision => 12, :scale => 8, :null => false
      t.decimal :altitude, :precision => 12, :scale => 8, :default => 0

      t.timestamps
    end
  end
end
