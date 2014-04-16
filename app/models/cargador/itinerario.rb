module Cargador
  class Itinerario < ActiveRecord::Base
    self.table_name = 'loader_itinerario'
    def self.out_data
      self.all()
    end
    def self.poly_line(nave, viaje)
      query = "select pl.coo, pl.distance, p.id id_port1, p2.id id_port2, p.lat lat_ori, p.lng lng_ori, p2.lat lat_des, p2.lng lng_des, i.codigo_pais, i.codigo_puerto, i.pais_dest, i.puerto_dest
              from loader_itinerario i
              inner join iz_list_ports p on p.code = i.codigo_puerto
              inner join iz_countries c on c.id = p.iz_country_id AND c.code = i.codigo_pais
              inner join iz_list_ports p2 on p2.code = i.puerto_dest
              inner join iz_countries c2 on c2.id = p2.iz_country_id AND c2.code = i.pais_dest
              left join iz_poly_lines pl on pl.ori = p.id AND pl.des = p2.id
              where i.numero_viaje = #{viaje} and i.nave = '#{nave}'
              order by i.fecha_zarpe_conf"
      data = ActiveRecord::Base.connection.execute(query)
      sw = FALSE
      data.each{|d|
        if d['coo'] == nil
          sw = TRUE
          hack_new_lines(d['id_port1'], d['id_port2'])
        end
      }
      if sw
        data = ActiveRecord::Base.connection.execute(query)
      end
      pol = []
      data.each{|d|
        a = d['coo'].split(',')
        if a.length.odd?
          #a.pop
        end
        for n in  (1..(a.length)).step(2)
          pol << {
              lat: a[n],
              lng: a[n-1]
          }
        end
      }
      pol
    end

    def self.hack_new_lines(id_port1, id_port2)
      require 'net/http'
      url = 'http://www.searates.com/map/calc-Route-Port-To-Port-Calc'
      uri = URI(url)
      res = Net::HTTP.post_form(uri, 'id_port1' => id_port1, 'id_port2' => id_port2)
      jres = JSON.parse(res.body)
      if jres['data']
        distance = jres['data'][0][0]
        coo = jres['data'][0][1][1..(jres['data'][0][1].length - 2)]
        Iz::PolyLine.create(distance: distance, coo: coo, ori: id_port1, des: id_port2)
      end
    end

    def self.ports(nave, viaje)
      query = "select p.lat lat_ori, p.lng lng_ori, p2.lat lat_des, p2.lng lng_des, i.codigo_pais, i.codigo_puerto, i.pais_dest, i.puerto_dest
              from loader_itinerario i
              inner join iz_list_ports p on p.code = i.codigo_puerto
              inner join iz_countries c on c.id = p.iz_country_id AND c.code = i.codigo_pais
              inner join iz_list_ports p2 on p2.code = i.puerto_dest
              inner join iz_countries c2 on c2.id = p2.iz_country_id AND c2.code = i.pais_dest
              where i.numero_viaje = #{viaje} and i.nave = '#{nave}'
              order by i.fecha_zarpe_conf"
      data = ActiveRecord::Base.connection.execute(query)
      list = []
      data.each{|d|
        list << {
            lat: d['lat_ori'],
            lng: d['lng_ori'],
            port: d['codigo_puerto'],
            port: d['codigo_puerto'],
            country: d['codigo_pais']
        }
      }
      if data.count > 0
        tmp = data[data.count - 1]
        list << {
            lat: tmp['lat_des'],
            lng: tmp['lng_des'],
            port: tmp['puerto_dest'],
            country: tmp['pais_dest']
        }
      end
      list
    end
    def self.get_naves()
      self.select(:nave).order(:nave).map(&:nave).uniq
    end
    """ RUTAS DE TODAS LAS NAVES """
    def self.travels
      self.select(:id, :nave, :codigo_pais, :codigo_puerto, :pais_dest, :puerto_dest, :zarpe_conf_dest).order(:nave, :zarpe_conf_dest)
    end

    def self.upload_csv(file_itineraries = '')
      filename = Rails.root.join('files', file_itineraries.original_filename)
      File.open(filename, 'wb') do |file|
        file.write(file_itineraries.read)
      end
    end

    def self.read_csv()
      begin
        file = File.open('/tmp/itineraries.csv', 'r')
        data = CSV.parse(file.read)
        file.close
        data
      rescue Exception => e
        "Error"
      end
    end

    def self.bulk_csv()
      config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join("config","config.yml")))
      script = Rails.root.join('script', 'itineraries.sh')
      etl = Rails.root.join('etl')
      data_integration = config[:default][:data_integration]
      system('bash ' + script.to_s + ' ' + etl.to_s + ' ' + data_integration.to_s)
    end

    def self.read_log()
      file = File.open('/tmp/itineraries.log', 'r')
      data = ''
      while (line = file.gets)
        data += "#{line}<br />"
      end
      file.close
      data
    end
  end
end
