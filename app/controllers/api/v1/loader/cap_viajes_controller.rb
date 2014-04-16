class Api::V1::Loader::CapViajesController < Api::ApplicationController
  def index
    iz_loader_cap = Iz::LoaderCap.all.limit(10)
    render json: {
        status: 'OK',
        iz_loader_cap: iz_loader_cap
    }
  end

  def travels_by_ship
    travels = Iz::CapacityResult.select(:viaje).where(nave: params[:nave]).order(:viaje).group(:viaje)
    list = []
    travels.each{|t|
      list.append(t.viaje)
    }
    render json: {
        result: 'OK',
        travels: list
    }
  end

  def routes_by_ship_travel
    lists = Iz::CapacityResult.where(viaje: params[:travel], nave: "#{params['ship']}").order(:fecha)
    list = []
    lists.each{|c|
      list << {
          max_teu: c.max_teu,
          used_teu: c.used_teu,
          max_plugs_teu: c.max_plugs_teu,
          used_plugs: c.used_plugs,
          max_weight: c.max_weight,
          used_weight: c.used_weight,
          empty_teu: c.empty_teu,
          cap_opp_value: c.cap_opp_value,
          plugs_opp_value: c.plugs_opp_value,
          weight_opp_value: c.weight_opp_value,
          nave: c.nave,
          viaje: c.viaje,
          fecha: c.fecha,
          puerto_origen: c.puerto_origen,
          puerto_destino: c.puerto_destino
      }
    }
    render json: {
        result: 'OK',
        route: list
    }
  end

  def unq_cap
    list = []
    Iz::CapacityResult.select(params[:field].to_sym).group(params[:field].to_sym).order(params[:field].to_sym).each{|l|
      list.append(eval("l.#{params[:field]}"))
    }
    render json: {
        status: 'OK',
        list: list
    }
  end
end
