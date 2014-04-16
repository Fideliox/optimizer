class Api::V1::Maps::EmptyController < Api::ApplicationController
  def group_containers
    containers = Iz::EmptyOd.select(:tipo_contenedor).group(:tipo_contenedor).order(:tipo_contenedor)
    list = []
    containers.each{|c|
      list.push(c.tipo_contenedor)
    }
    render json: {
        result: 'OK',
        list: list
    }
  end
  def coordinates
    type_container = params[:type_container]
    containers = Iz::EmptyOd.where(:tipo_contenedor => type_container)
    list = []
    containers.each{|c|
      list << {
          date: c.fecha,
          location: c.origen,
          destination: c.destino,
          container: c.contenedores,
          container_type: c.tipo_contenedor,
          ship: c.nave
      }
    }
    render json: {
        result: 'OK',
        list: list
    }
  end
end
