class CreateIzLoaderCaps < ActiveRecord::Migration
  def change
    create_table :iz_loader_caps do |t|
      t.string :location, :limit => 5
      t.string :destination, :limit => 5
      t.string :sentido, :limit => 2
      t.string :nave, :limit => 100
      t.string :servicio, :limit => 3
      t.integer :viaje
      t.datetime :fecha_arribo
      t.datetime :fecha_zarpe
      t.float :max_teu
      t.float :max_plugs
      t.float :max_weight
      t.string :resource

      t.timestamps
    end
  end
end
