class CreateCourseEntries < ActiveRecord::Migration
  def change
    create_table :course_entries do |t|
      t.string :title
      t.string :course
      t.string :instructor
      t.string :reg_limit
      t.string :campus
      t.string :bldg
      t.string :room
      t.string :days
      t.string :start
      t.string :end

      t.timestamps
    end
  end
end
