class Api::V1::Purchase::OriginDestinationController < Api::ApplicationController
  def index
    list = Array.new

    Cargador::Itinerario.all.each {|i|
      list << { codigo_puerto: i.codigo_puerto }
    }

    # Response
    render json: list
    #respond_with({ list: list })
  end

end
