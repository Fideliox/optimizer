class Api::V1::Maps::PortsController < Api::ApplicationController
  def index
    list = []
    empty =  Inzpiral::PortCcni.all()
    empty.each{|p|
      list << {
          port: p.port,
          code_port: p.code,
          country: p.country,
          code_country: p.code_country,
          lat: p.lat,
          lng: p.lng,
          telephone: p.telephone,
          web: p.web
      }
    }
    render json: {list: list}
  end
  def origin
    list = []
    end_date = params[:end_date]
    start_date = params[:start_date]
    ori = Inzpiral::EmptyOd.get_containers('ori', start_date, end_date)
    ori.each{|t|
      list << {
          country: t['country'],
          telephone: t['telephone'],
          web: t['web'],
          port: t['port'],
          ori: {
            port: t['origen'],
            lat: t['lat_ori'],
            lng: t['lng_ori'],
            code_country: t['code_country']
          },
          des: {
              port: t['destino'],
              lat: t['lat_des'],
              lng: t['lng_des']
          }
      }
    }
    render json: {
        list: list
    }

  end
  def teus
    list = []
    end_date = params[:end_date]
    start_date = params[:start_date]
    teus = Inzpiral::EmptyOd.get_containers('des', start_date, end_date)
    teus.each{|t|
      list << {
          containers: t['containers'],
          port: t['port'],
          code_port: t['code_port'],
          country: t['country'],
          code_country: t['code_country'],
          lat: t['lat'],
          lng: t['lng'],
          telephone: t['telephone'],
          web: t['web']
      }
    }
    render json: {
        list: list
    }
  end
end