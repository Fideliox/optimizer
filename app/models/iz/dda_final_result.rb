class Iz::DdaFinalResult < ActiveRecord::Base
  def detail
    query = "SELECT r.cost_per_teu, r.sol_units_teu, r.leg, d.* FROM loader_demanda d
            INNER JOIN iz_dda_final_results_detail r ON trim(r.dda) = concat(d.cnt_type_iso,':',d.item_type,':',d.por_onu,':',d.pod_onu,':',d.servicio1,':',d.nave1,':',d.sentido1,':',d.viaje1,':',d.direct_ts,':',d.comm_name,':',d.issuer_name,':',d.customer_type,':',d.pol_onu,':',d.podl_onu,':',d.flete_all_in_us_un)
            WHERE "
  end
end