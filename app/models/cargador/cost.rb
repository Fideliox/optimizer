module Cargador
  class Cost < ActiveRecord::Base
    self.table_name = 'loader_costos'
    def self.out_data
      self.all()
    end
  end
end
