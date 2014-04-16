class Api::V1::Enterprise::LocationDefinitionsMtpController < Api::ApplicationController
  def get_ports
    port = []
    Eo::EnterpriseLocationDefinitionsMtp.where("\"Location\" like 'US%'").order("\"Location\"").each { |p|
      port << {
          port: p.Location
      }
    }
    render json: port
  end
end