class Api::V1::Loader::DemandsController < Api::ApplicationController

  def filter
    demanda = Cargador::Demanda.filter(params)
    render json: {
        status: 'OK',
        demands: demanda
    }
  end
  def status
    port = "select p.* from iz_list_ports p
            inner join iz_countries c on p.iz_country_id = c.id
            where p.code = '#{params['code'][2..4]}' and c.code = '#{params['code'][0..1]}'"
    rport = ActiveRecord::Base.connection.execute(port)
    puerto = ''
    lat = ''
    lng =''
    rport.each{|r|
      puerto = r['name']
      lat = r['lat']
      lng = r['lng']
    }
    des = "SELECT split_part(dda, ':', 1) as container, sum(sol_units_teu) as teu FROM iz_dda_final_results
                  WHERE
                  split_part(dda, ':', 4) ='#{params['code']}' AND
                  split_part(dda, ':', 8) = '#{params['travel']}' AND
                  split_part(dda, ':', 6) = '#{params['ship']}'
          GROUP BY split_part(dda, ':', 1)"
    ori = "SELECT split_part(dda, ':', 1) as container, sum(sol_units_teu) as teu FROM iz_dda_final_results
                  WHERE
                  split_part(dda, ':', 3) ='#{params['code']}' AND
                  split_part(dda, ':', 8) = '#{params['travel']}' AND
                  split_part(dda, ':', 6) = '#{params['ship']}'
          GROUP BY split_part(dda, ':', 1)"
    rori = ActiveRecord::Base.connection.execute(ori)
    rdes = ActiveRecord::Base.connection.execute(des)
    list_ori = []
    rori.each{|r|
      list_ori << {
          container: r['container'],
          teu: r['teu']
      }
    }
    list_des = []
    rdes.each{|r|
      list_des << {
          container: r['container'],
          teu: r['teu']
      }
    }
    render json: {
        result: 'OK',
        list: {
            load: list_ori,
            unload: list_des
        },
        puerto: puerto,
        lat: lat,
        lng: lng
    }
  end
  def move
    ori = "SELECT split_part(dda, ':', 1) as container, sum(sol_units_teu) as teu FROM iz_dda_final_results
                  WHERE
                  split_part(dda, ':', 3) ='#{params['code_ori']}' AND
                  split_part(dda, ':', 8) = '#{params['travel']}' AND
                  split_part(dda, ':', 6) = '#{params['ship']}'
          GROUP BY split_part(dda, ':', 1)"
    rori = ActiveRecord::Base.connection.execute(ori)
    list_ori = []
    rori.each{|r|
      list_ori << {
          container: r['container'],
          teu: r['teu']
      }
    }
    render json: {
        result: 'OK',
        status: list_ori
    }
  end
  def travels
    nave = params[:nave]
    viaje = params[:viaje]
    pol = Cargador::Itinerario.poly_line(nave, viaje)
    render json: {
        result: 'OK',
        coordinates: pol
    }
  end

  def ports
    nave = params[:nave]
    viaje = params[:viaje]
    ports = Cargador::Itinerario.ports(nave, viaje)
    render json: {
        result: 'OK',
        ports: ports
    }
  end

  def get_viaje1_by_nave1
    data = Cargador::Demanda.select(:viaje1).where(nave1: params[:field]).group(:viaje1).order(:viaje1)
    list = []
    data.each{|d|
      list.push(d.viaje1)
    }
    render json: {
        result: 'OK',
        data: list
    }
  end

  def unique
    data = Cargador::Demanda.unique(params[:field], nil)
    render json: {
        status: 'OK',
        data: data
    }
  end
end
