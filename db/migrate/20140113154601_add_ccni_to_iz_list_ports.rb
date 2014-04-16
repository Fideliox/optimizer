class AddCcniToIzListPorts < ActiveRecord::Migration
  def change
    add_column :iz_list_ports, :ccni, :boolean
  end
end
