class Api::V1::Results::StatusController < Api::ApplicationController
  def list_leg
    query = "select concat(split_part(resource, ':', 4), '-->', split_part(resource, ':', 5)) as leg from iz_capacity_results
              where servicio = '#{params[:service]}'
              group by
              concat(split_part(resource, ':', 4), '-->', split_part(resource, ':', 5)), split_part(resource, ':', 4)

              order by
              split_part(resource, ':', 4)"
    result = ActiveRecord::Base.connection.execute(query)
    list = []
    result.each{|r|
      list.append(r['leg'])
    }
    render json: {
        result: 'OK',
        list: list
    }
  end
  def list_services
    services = Iz::CapacityResult.select(:servicio).group(:servicio).order(:servicio)
    list = []
    services.each{|s|
      list.append(s.servicio)
    }
    render json: {
        result: 'OK',
        list: list
    }
  end

  def search
    status = Iz::DdaFinalResultsDetail.search_status(params)
    list = []
    status.each{|s|
      tmp = []
      s['nave'].split(' ').each{|s|  tmp.append(s.capitalize)  }
      list << {
          ship: tmp.join(' '),
          travel: s['viaje'],
          date: s['fecha'].to_date.strftime("%d-%m-%Y"),
          resource: s['resource']
      }
    }
    render json: {
        result: 'OK',
        list: list
    }
  end

  def containers
    query = "select container_type, sum(empty) as empty, sum(\"full\") as \"full\" from (
              select
              container_type,
              case when tag = 'E' then teu else 0 end empty,
              case when tag = 'F' then teu else 0 end \"full\"
              from
              (
              select
              case when split_part(dda, ':', 2) = 'EMPTY' then 'E' else 'F' end tag,
              split_part(dda, ':', 1) container_type,
              sum(sol_units_teu) teu
              from iz_dda_final_results_detail
              where leg = '#{params[:leg]}'
              group by
              split_part(dda, ':', 1), case when split_part(dda, ':', 2) = 'EMPTY' then 'E' else 'F' end
              ) x ) x
              group by container_type"

    result = ActiveRecord::Base.connection.execute(query)
    list = []
    result.each{|r|
      list << {
          name: r['container_type'],
          value: [{name: r['full'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse},{name: r['empty'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}]
      }
    }
    render json: {
        items: list
    }
  end

  def status
    query = "select  max_weight, used_weight , max_teu, used_teu, empty_teu, max_plugs_teu, used_plugs  from iz_capacity_results
            where resource = '#{params[:leg]}'"
    result = ActiveRecord::Base.connection.execute(query)
    list = []
    result.each{|r|
      list << {
          name: 'Weight',
          value: [{ name: r['max_weight'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}, { name: r['used_weight'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}]
      }
      list << {
          name: 'TEU',
          value: [{ name: r['max_teu'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}, { name: r['used_teu'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}]
      }
      list << {
          name: 'Empty',
          value: [{ name: '-'}, { name: r['empty_teu'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}]
      }
      list << {
          name: 'Plugs',
          value: [{ name: r['max_plugs_teu'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}, { name: r['used_plugs'].to_f.round().to_s.reverse.gsub(/...(?=.)/,'\&.').reverse}]
      }
    }
    render json: {
        result: 'OK',
        items: list
    }
  end
end