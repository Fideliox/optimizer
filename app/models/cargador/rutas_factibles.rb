module Cargador
  class RutasFactibles < ActiveRecord::Base
    self.table_name = 'loader_rutas_naves_factibles'
    def self.no_routes
      items = Cargador::RutasFactibles.where(rutas_factibles: '').all
      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "No routes") do |sheet|
        sheet.add_row ["pol_onu", "pod_onu", "start_date", "nave_ini", "servicio", "max_tt", "port_tt"]
        items.each{|c|
          sheet.add_row [c.pol_onu, c.pod_onu, c.start_date, c.nave_ini, c.servicio, c.max_tt, c.port_tt]
        }
      end
      p.use_shared_strings = true
      filename = Rails.root.join('../../files', 'no_routes.xlsx')
      p.serialize(filename)
    end
  end
end
