class Api::V1::Results::WeekController < Api::ApplicationController
  def list_week_leg
    list = Iz::CapacityResult.select("to_char(fecha, 'IW')").group('1').order('1').pluck("to_char(fecha, 'IW')")
    render json: {
        result: 'OK',
        list: list
    }
  end
  def list_vessel
    ships = Iz::CapacityResult.select(:nave).group(:nave).order(:nave).pluck(:nave)
    render json: {
        result: 'OK',
        list: ships
    }
  end
  def list_services
    services = Iz::CapacityResult.select(:servicio).group(:servicio).order(:servicio).pluck(:servicio)
    render json: {
        result: 'OK',
        list: services
    }
  end
  def list_voyage
    voyage = Iz::CapacityResult.select(:viaje).where(nave: params[:vessel]).group(:viaje).order(:viaje).pluck(:viaje)
    render json: {
        result: 'OK',
        list: voyage
    }
  end
  def list_origin
    origins = Iz::CapacityResult.select(:puerto_origen).where(nave: params[:vessel]).group(:puerto_origen).order(:puerto_origen).pluck(:puerto_origen)
    render json: {
        result: 'OK',
        list: origins
    }
  end
  def list_destination
    destinations = Iz::CapacityResult.select(:puerto_destino).where(puerto_origen: params[:origin]).group(:puerto_destino).order(:puerto_destino).pluck(:puerto_destino)

    render json: {
        result: 'OK',
        list: destinations
    }
  end
  def list_month
    list = Iz::CapacityResult.select("to_char(fecha, 'MM')").group('1').order('1').pluck("to_char(fecha, 'MM')")
    render json: {
        result: 'OK',
        list: list
    }
  end
end