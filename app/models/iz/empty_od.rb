class Iz::EmptyOd < ActiveRecord::Base
  self.table_name = 'iz_empty_od'
  def self.generate_xlsx
    Thread.new do
      items = self.all
      self.truncate_process
      self.create_process(items.count)
      p = Axlsx::Package.new
      p.workbook.add_worksheet(:name => "Empty") do |sheet|
        sheet.add_row ["Tipo contenedor","Origen","Destino","Fecha embarque","Fecha arribo","Contenedores","Puerto transbordo","Nave trasbordo","Nave inicial","Servicio","Viaje embarque","Viaje arribo","Destino nave","Fecha arribo nave","Contenedores nave"]
        i = 1
        items.each{|c|
          sheet.add_row [c.tipo_contenedor,c.origen,c.destino,c.embarque_fecha,c.fecha_final_arribo,c.contenedores,c.transfer_port,c.to_resource,c.nave,c.servicio,c.embarque_viaje,c.arribo_viaje,c.final_destino,c.fecha,c.final_contenedores]
          self.update_status(i)
          i += 1
        }
      end
      p.use_shared_strings = true
      filename = Rails.root.join('../../files', 'empty.xlsx')
      p.serialize(filename)
    end
  end
  def self.truncate_process
    sql = "delete from iz_status_python where process = 'empty_od_xlsx'"
    ActiveRecord::Base.connection.execute(sql)
  end
  def self.create_process(total)
    sql = "INSERT INTO iz_status_python(process, actual, limite, total, ready, filename) VALUES ('empty_od_xlsx', 0, 0, #{total}, 0, 'empty.xlsx')"
    ActiveRecord::Base.connection.execute(sql)
  end
  def self.update_status(actual)
    sql = "UPDATE iz_status_python set actual = #{actual} WHERE process = 'empty_od_xlsx'"
    ActiveRecord::Base.connection.execute(sql)
  end
end