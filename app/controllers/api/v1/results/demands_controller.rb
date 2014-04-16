class Api::V1::Results::DemandsController < Api::ApplicationController
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
  def search
    list = []
    result = Iz::CapacityResult.all
    result = result.where(nave: params[:nave]) if params[:nave] && params[:nave] != ''
    result = result.where(viaje: params[:viaje]) if params[:viaje] && params[:viaje] != ''
    result = result.where(puerto_origen: params[:puerto_origen]) if params[:puerto_origen] && params[:puerto_origen] != ''
    result = result.where(puerto_destino: params[:puerto_destino]) if params[:puerto_destino] && params[:puerto_destino] != ''
    result.each{|r|
      list << {
          nave: r.nave,
          puerto_origen: r.puerto_origen,
          puerto_destino: r.puerto_destino,
          viaje: r.viaje,
          resource: r.resource,
          max_teu: r.max_teu,
          used_teu: r.used_teu,
          empty_teu: r.empty_teu,
          max_plugs_teu: r.max_plugs_teu,
          used_plugs: r.used_plugs,
          max_weight: r.max_weight,
          used_weight: r.used_weight,
      }
    } if result
    render json: {
        result: 'OK',
        list: list
    }
  end
  def filter_travel
    list = []
    demanda = Iz::CapacityResult.select(:viaje).group(:viaje).order(:viaje)
    demanda = demanda.where(nave: params[:ship]) if params[:ship] != '' && params[:ship]
    demanda.each{|l|
      list.append(l.viaje)
    } if demanda
    render json: {
        result: 'OK',
        list: list
    }
  end
  def filter_por_onu
    list = []
    demanda = Iz::CapacityResult.select(:puerto_origen).group(:puerto_origen).order(:puerto_origen)
    demanda = demanda.where(nave: params[:ship]) if params[:ship] != '' && params[:ship]
    demanda.each{|l|
      list.append(l.puerto_origen)
    } if demanda
    render json: {
        result: 'OK',
        list: list
    }
  end
  def filter_pod_onu
    list = []
    demanda = Iz::CapacityResult.select(:puerto_destino).group(:puerto_destino).order(:puerto_destino)
    demanda = demanda.where(puerto_origen: params[:location]) if params[:location] != '' && params[:location]
    demanda = demanda.where(nave: params[:ship]) if params[:ship] != '' && params[:ship]
    demanda = demanda.where(viaje: params[:travel]) if params[:travel] != '' && params[:travel]
    demanda.each{|l|
      list.append(l.puerto_destino)
    } if demanda
    render json: {
        result: 'OK',
        list: list
    }
  end
  def detail
    query = "SELECT * FROM iz_dda_final_results_detail
            WHERE
              trim(leg) = trim('#{params[:resource]}')
            ORDER BY type asc, opp_value_per_teu desc"
    result_detail = ActiveRecord::Base.connection.execute(query)
    list = []
    result_detail.each{|r|
      list << {
          dda: r['dda'],
          cost_per_teu_leg: r['cost_per_teu_leg'],
          total_cost_per_teu_leg: r['total_cost_per_teu_leg'],
          sol_units_teu: r['sol_units_teu'],
          rate_per_teu: r['rate_per_teu'],
          opp_value_per_teu: r['opp_value_per_teu'],
          leg: r['leg'],
          max_units: r['max_units'],
          type: r['type']
      }
    }
    render json: {
        result: 'OK',
        list: result_detail
    }
  end
  def dda
    query = "SELECT * FROM iz_dda_final_results_detail
            WHERE
              trim(dda) = trim('#{params[:dda]}')
            ORDER BY type asc, opp_value_per_teu desc"
    result_detail = ActiveRecord::Base.connection.execute(query)
    list = []
    result_detail.each{|r|
      list << {
          dda: r['dda'],
          cost_per_teu_leg: r['cost_per_teu_leg'],
          total_cost_per_teu_leg: r['total_cost_per_teu_leg'],
          sol_units_teu: r['sol_units_teu'],
          rate_per_teu: r['rate_per_teu'],
          opp_value_per_teu: r['opp_value_per_teu'],
          leg: r['leg'],
          max_units: r['max_units'],
          type: r['type']
      }
    }
    render json: {
        result: 'OK',
        list: result_detail
    }
  end
  def results
    result = Cargador::Demanda.out_demand
    list = []
    result.each do |c|
      list << {
          servicio1: c['servicio1'],
          sentido1: c['sentido1'],
          nave1: c['nave1'],
          viaje1: c['viaje1'],
          por_onu: c['por_onu'],
          pol_onu: c['pol_onu'],
          pod_onu: c['pod_onu'],
          podl_onu: c['podl_onu'],
          direct_ts: c['direct_ts'],
          item_type: c['item_type'],
          cnt_type_iso: c['cnt_type_iso'],
          comm_name: c['comm_name'],
          issuer_name: c['issuer_name'],
          customer_type: c['customer_type'],
          cantidad: c['cantidad'],
          freight_tons_un: c['freight_tons_un'],
          weight_un: c['weight_un'],
          teus: c['teus'],
          lost_teus: c['lost_teus'],
          flete_all_in_us_un: c['flete_all_in_us_un'],
          accepted: c['accepted'],
          not_accepted: c['not_accepted'],
          cost: c['cost'],
          accepted_cnts: c['accepted_cnts']
      }
      render json: {
          list: list
        }
    end
  end
  def generate_xlsx
    Cargador::Demanda.generate_xlsx
    render status: 200,
           json: { result: 'OK' }
  end
end

