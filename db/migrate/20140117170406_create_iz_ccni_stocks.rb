class CreateIzCcniStocks < ActiveRecord::Migration
  def change
    create_table :iz_ccni_stocks do |t|
      t.string :port, :limit => 5
      t.string :container_type, :limit => 5
      t.date :date
      t.float :in_full
      t.float :in_empty
      t.float :buy
      t.float :out_full
      t.float :out_empty
      t.float :stock


      t.timestamps
    end
  end
end
