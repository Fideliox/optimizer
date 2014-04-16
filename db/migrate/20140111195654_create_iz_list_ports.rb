class CreateIzListPorts < ActiveRecord::Migration
  def change
    create_table :iz_list_ports do |t|
      t.string :name, :limit => 200
      t.string :code, :limit => 3
      t.references :iz_country
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
