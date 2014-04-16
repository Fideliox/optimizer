module Cargador
  class Capacidad < ActiveRecord::Base
    self.table_name = 'loader_capacidades'

    def self.upload_csv(filename = '')
      File.open('/tmp/capabilities.csv', 'wb') do |file|
        file.write(filename.read)
      end
    end
    def self.out_data
      self.all()
    end
    def self.read_csv(filename = '')
      begin
        file = File.open('/tmp/capabilities.csv', 'r')
        data = CSV.parse(file.read)
        file.close
        data
      rescue Exception => e
        "Error"
      end
    end

    def self.bulk_csv()
      script = Rails.root.join('script', 'capabilities.sh')
      config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join("config","config.yml")))
      etl = Rails.root.join('etl')
      data_integration = config[:default][:data_integration]
      system('bash ' + script.to_s + ' ' + etl.to_s + ' ' + data_integration.to_s)
    end

    def self.read_log()
      file = File.open('/tmp/capabilities.log', 'r')
      data = ''
      while (line = file.gets)
        data += "#{line}<br />"
      end
      file.close
      data
    end

  end
end
