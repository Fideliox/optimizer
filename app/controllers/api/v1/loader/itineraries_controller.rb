class Api::V1::Loader::ItinerariesController < Api::ApplicationController
  def index
    list = Cargador::Itinerario.all().limit(params[:limit]).offset(params[:offset])
    rows = Cargador::Itinerario.all().count
    render json: {
        list: list,
        rows: rows
    }
  end
  def update
    render json: {status: true}
  end
  def create
    begin
      Inzpiral::File.create({ name: params[:filename].to_s, iz_file_type_id: 2 })
      render json: 'OK'
    rescue Exception => e
      render json: 'FAIL'
    end
  end
  def travels
    travels = Cargador::Itinerario.travels()
    render json: {
        result: 'OK',
        travels: travels
    }
  end
end





