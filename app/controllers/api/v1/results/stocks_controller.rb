class Api::V1::Results::StocksController < Api::ApplicationController
  def list_containers
    list = Iz::CcniStock.select(:container_type).group(:container_type).order(:container_type).pluck(:container_type)
    render json: {
        result: 'OK',
        list: list
    }
  end
  def list_countries
    query = 'select c.id, c.code, c.name from iz_countries c
            inner join iz_list_ports p on c.id = p.iz_country_id
            where p.code is not null
            group by c.id, c.code, c.name
            order by c.code'
    countries = ActiveRecord::Base.connection.execute(query)
    list = []
    countries.each{|c|
      list << {
          name: c['name'],
          code: c['code'],
          id: c['id']
      }
    }
    render json: { result: 'OK', countries: list}
  end
  def list_ports
    ports = Iz::ListPort.where('code is not NULL').order(:code)
    ports = ports.where(:iz_country_id => params[:country_id]) if params[:country_id] && params[:country_id] != ''
    list = []
    ports.each{|c|
      list << {
          name: c.name,
          code: c.code,
          country: c.iz_country.code,
          id: c.id
      }
    }
    render json: { result: 'OK', ports: list}
  end
  def search
    containers = params[:containers].split(',')
    list_containers = []
    containers.each{|c|
      query = "SELECT port as port,container_type , date as date, sum(in_full) as in_full,sum(in_empty) as in_empty,
            sum(buy) as buy, sum(sell) as sell, sum(out_full) as out_full, sum(out_empty) as out_empty,
            sum(in_full+in_empty+buy+sell+out_full+out_empty+from_stock)  as empty_moves, sum(stock) as stock_ini,
            sum(from_stock) as from_stock FROM iz_ccni_stocks
            WHERE
            port = '#{params[:port]}'
            AND
            container_type = '#{c}'
            GROUP BY port, container_type, date
            ORDER BY date"
      result = ActiveRecord::Base.connection.execute(query)
      list = []
      result.each{|r|
        list << {
            port: r['port'],
            container_type: r['container_type'],
            date: r['date'],
            in_full: r['in_full'],
            in_empty: r['in_empty'],
            buy: r['buy'],
            sell: r['sell'],
            out_full: r['out_full'],
            out_empty: r['out_empty'],
            empty_moves: r['empty_moves'],
            stock_ini: r['stock_ini'],
            from_stock: r['from_stock']
        }
      }
      list_containers << list
    }
=begin
    container_type = ' 1=1 '
    port = ' 1=1 '

=end
    render json: {
        result: 'OK',
        containers: list_containers
    }
  end
end