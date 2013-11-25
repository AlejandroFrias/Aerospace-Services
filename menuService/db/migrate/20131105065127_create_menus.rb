class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :school
      t.string :meal_type
      t.string :day
      t.string :start
      t.string :end

      t.timestamps
    end

    create_table :meals do |t|
      t.belongs_to :menu
      t.string :name
      t.integer :menu_id

      t.timestamps
    end

  end
end
