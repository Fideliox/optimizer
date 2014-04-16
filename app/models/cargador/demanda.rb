module Cargador
  class Demanda < ActiveRecord::Base
    self.table_name = 'loader_demanda'
    def self.upload_csv(filename = '')
      File.open('/tmp/demands.csv', 'wb') do |file|
        file.write(filename.read)
      end
    end
    def self.out_data
      self.all()
    end
    def self.read_csv(filename = '')
      begin
        file = File.open('/tmp/demands.csv', 'r')
        data = CSV.parse(file.read)
        file.close
        data
      rescue Exception => e
        "Error"
      end
    end

    def self.bulk_csv()
      config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join("config","config.yml")))
      script = Rails.root.join('script', 'demands.sh')
      etl = Rails.root.join('etl')
      data_integration = config[:default][:data_integration]
      system('bash ' + script.to_s + ' ' + etl.to_s + ' ' + data_integration.to_s)
    end
    def self.read_log()
      file = File.open('/tmp/demands.log', 'r')
      data = ''
      while (line = file.gets)
        data += "#{line}<br />"
      end
      file.close
      data
    end
    def self.filter(params = {})
      sql = 'SELECT
              l.servicio1, l.sentido1, l.nave1, l.viaje1, l.por_onu, l.pol_onu, l.podl_onu, l.direct_ts, l.item_type,
              l.cnt_type_iso, l.comm_name, l.issuer_name, l.customer_type, l.cantidad, l.freight_tons_un, l.weight_un,
              l.teus, ((l.weight_un/l.teus) * sol_units_teu) peso, l.lost_teus, l.flete_all_in_us_un,
              l.other_cost, i.cost_per_teu, i.sol_units_teu  accept, (l.teus - i.sol_units_teu )no_accept
            FROM
              loader_demanda l
            LEFT JOIN iz_dda_final_results i on concat(l.cnt_type_iso, \':\', l.item_type, \':\', l.pol_onu, \':\', l.pod_onu, \':\', l.servicio1, \':\', l.nave1, \':\', l.sentido1, \':\', l.viaje1, \':\', l.direct_ts, \':\', l.comm_name, \':\', l.issuer_name, \':\',  l.customer_type, \':\', l.por_onu, \':\', l.podl_onu, \':\', l.flete_all_in_us_un) = trim(i.dda)
            LIMIT 10'
      ActiveRecord::Base.connection.execute(sql)
    end
    def self.unique(field, conditions = '')

      sql = "SELECT distinct l.#{field} FROM loader_demanda l order by l.#{field}"
      rows = ActiveRecord::Base.connection.execute(sql)
      data = []
      rows.each do |row|
        data << eval("row['#{field}']")
      end
      data
    end
    def self.generate_xlsx
      Thread.new do
        items = self.out_demand
        self.truncate_process
        self.create_process(items.count)
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Results Demands") do |sheet|
          sheet.add_row ["servicio1","sentido1","nave1","viaje1","por_onu","pol_onu","pod_onu","podl_onu",
                         "direct_ts","item_type","cnt_type_iso","comm_name","issuer_name","customer_type",
                         "cantidad","freight_tons_un","weight_un","teus","lost_teus","flete_all_in_us_un",
                         "accepted","not_accepted","cost_per_teu","accepted_cnts"]
          i = 1
          items.each{|c|
            sheet.add_row [c['servicio1'],c['sentido1'],c['nave1'],c['viaje1'],c['por_onu'],c['pol_onu'],
                           c['pod_onu'],c['podl_onu'],c['direct_ts'],c['item_type'],c['cnt_type_iso'],
                           c['comm_name'],c['issuer_name'],c['customer_type'],c['cantidad'],c['freight_tons_un'],
                           c['weight_un'],c['teus'],c['lost_teus'],c['flete_all_in_us_un'],c['accepted'],
                           c['not_accepted'],c['cost_per_teu'].to_f.round,c['accepted_cnts']]
            self.update_status(i)
            i += 1
          }
        end
        p.use_shared_strings = true
        filename = Rails.root.join('../../files', 'demands.xlsx')
        p.serialize(filename)
      end
    end
    def self.out_demand
      sql = "SELECT
                  d.servicio1,d.sentido1,d.nave1,d.viaje1,d.por_onu,d.pol_onu,d.pod_onu,d.podl_onu,d.direct_ts,d.item_type,
                  d.cnt_type_iso,d.comm_name,d.issuer_name,d.customer_type,d.cantidad,d.freight_tons_un,d.weight_un,
                  d.teus,d.lost_teus,d.flete_all_in_us_un,
                  \"TotalSolutionUnits\" accepted,
                  (d.teus - \"TotalSolutionUnits\") not_accepted,
                  CASE WHEN iz.cost_per_teu is not null THEN  iz.cost_per_teu ELSE \"CostPerUnit\" + iz.cost_per_teu END cost_per_teu,
                  CASE WHEN d.cnt_type_iso like '2%' THEN  \"TotalSolutionUnits\" ELSE \"TotalSolutionUnits\"/2 END accepted_cnts
                  FROM loader_demanda  d
                  left join iz_query_send_shipments r ON
                  split_part(substring(\"ItemDescription\",21,255),'*',1) = concat(cnt_type_iso,':',item_type,':',pol_onu,':',pod_onu,':',servicio1,':',upper(nave1),
                  ':',sentido1,':',viaje1,':',direct_ts,':',
                  substring(comm_name,1,25),':',substring(issuer_name,1,20),':',customer_type,':',por_onu,':',podl_onu,':',flete_all_in_us_un)
                  left join iz_dda_final_results iz on iz.dda =  (concat(cnt_type_iso, ':', item_type, ':', pol_onu, ':', pod_onu, ':', servicio1 ,
                  ':', nave1, ':', sentido1, ':', viaje1, ':', direct_ts, ':',  comm_name, ':', issuer_name,
                  ':', customer_type, ':', por_onu, ':', podl_onu, ':', flete_all_in_us_un))"
      ActiveRecord::Base.connection.execute(sql)
    end
    def self.truncate_process
      sql = "delete from iz_status_python where process = 'generate_xlsx'"
      ActiveRecord::Base.connection.execute(sql)
    end
    def self.create_process(total)
      sql = "INSERT INTO iz_status_python(process, actual, limite, total, ready, filename) VALUES ('generate_xlsx', 0, 0, #{total}, 0, 'demands.xlsx')"
      ActiveRecord::Base.connection.execute(sql)
    end
    def self.update_status(actual)
      sql = "UPDATE iz_status_python set actual = #{actual} WHERE process = 'generate_xlsx'"
      ActiveRecord::Base.connection.execute(sql)
    end
 end
end
