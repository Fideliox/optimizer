class Iz::DdaFinalResultsDetail < ActiveRecord::Base
  self.table_name = 'iz_dda_final_results_detail'
  def self.out_data
    query = 'select dda, cost_per_teu_leg, total_cost_per_teu_leg, sol_units_teu, rate_per_teu, opp_value_per_teu,
            leg, max_units, type, leg_distance from iz_dda_final_results_detail '
    ActiveRecord::Base.connection.execute(query)
    self.all()
  end
  def self.result(filter = '')
    query = "SELECT * FROM iz_dda_final_results_detail WHERE trim(dda) = trim('#{filter}')"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.search_status(params = {})
    query = "select b.nave, b.viaje, b.fecha, b.resource from  iz_capacity_results b
            where
            servicio = '#{params[:service]}' and
            puerto_origen = '#{params[:port_origin]}' and
            puerto_destino = '#{params[:port_destination]}'
          group by  b.nave, b.viaje, b.fecha, b.resource
          order by b.fecha"
    ActiveRecord::Base.connection.execute(query)
  end
end