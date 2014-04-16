module Cargador
  class InventoryContainer < ActiveRecord::Base
    self.table_name = 'loader_inventario_contenedores'
    def self.out_data
      self.all()
    end
  end
end
