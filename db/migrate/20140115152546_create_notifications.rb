class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.string :flash
      t.string :comment

      t.timestamps
    end
  end
end
