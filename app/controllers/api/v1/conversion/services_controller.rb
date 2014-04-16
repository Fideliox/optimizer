class Api::V1::Conversion::ServicesController < Api::ApplicationController

  def init(codigo_pais, codigo_puerto, start_date, end_date, sentido, codigo_puerto_origen, codigo_puerto_dest, sw)
    items = Loader::Itinerario.where(:codigo_pais => codigo_pais,
                                     :codigo_puerto => codigo_puerto,
                                     :fecha_zarpe_conf => start_date.to_datetime.beginning_of_day..(start_date.to_datetime + 11).end_of_day
    ).where('arribo_conf_dest < ? ', end_date)
    i = 0
    @profundidad += 1
    list = []
    items.each{ |item|
      i+=1
      @indexOf += "#{(i-1).to_s}."
      codigo_pais = item.pais_dest.to_s
      codigo_puerto = item.puerto_dest.to_s
      start_date =   item.arribo_conf_dest.to_date
      codigo_puerto_destino =  codigo_puerto
      codigo_puerto_origen =  item.codigo_puerto.to_s if i == 1
      @path +=  codigo_puerto_origen + ' - '
      if sw
        # @tmp << branch(list)
      #  break
      end
      fin = ''
      if codigo_puerto_destino == codigo_puerto_dest
         fin = 'LLEGE'
        sw = true
      else
        sw = false
      end
      @path =  codigo_puerto_origen + ' - ' if @profundidad == 1
      @indexOf = "#{(i-1).to_s}."  if @profundidad == 1
      list << {
          fin: fin,
          indexOf: @indexOf,
          path: @path,
          sentido: sentido,
          fecha_zarpe_conf:   item.fecha_zarpe_conf.to_s,
          codigo_puerto_origen: codigo_puerto_origen,
          codigo_puerto_destino: codigo_puerto_destino,
          route: init(codigo_pais, codigo_puerto, start_date, end_date, sentido, codigo_puerto_origen, codigo_puerto_dest, sw)
      }
      codigo_puerto_origen =  item.codigo_puerto.to_s
      @path = @path.split(' - ')[0..-2].join(' - ') + ' - '
      @indexOf = @indexOf.split('.')[0..-2].join('.') + '.'
      @profundidad -= 1
    }
    @tmp = list
    list
  end

  def branch(items)
    items.each do |item|
      list << {
          fin: item[:fin],
          sentido: item[:sentido],
          codigo_puerto_origen: item[:codigo_puerto_origen],
          codigo_puerto_destino: item[:codigo_puerto_destino],
          route: branch(item[:route])
      }
    end
    list
  end

  def route
    @indexOf = ''
    @profundidad = 0
    @profundidad_old = 1
    @route = []
    @tmp = []
    @path = ''
    codigo_pais = "CL"
    codigo_puerto = "SAI"
    codigo_puerto_origen = codigo_puerto
    start_date = "2013-05-14".to_date
    end_date =   start_date + 15
    codigo_pais_dest = "US"
    codigo_puerto_dest = "CLL"
    sentido = "NB"
    list = init(codigo_pais, codigo_puerto, start_date, end_date, sentido, codigo_puerto_origen, codigo_puerto_dest, false)



    respond_with(route: list  )


  end
  def index
    list = [{
                number: 3456,
                shipping: 'AMANDA',
                ori_des: [
                    {
                        origin: :A,
                        destination: :B,
                        color: :yellow
                    },
                    {
                        origin: :C,
                        destination: :E,
                        color: :yellow
                    },
                    {
                        origin: :E,
                        destination: :K,
                        color: :green
                    }
                ]
            },
            {
                number: 3455,
                shipping:  'BAMSA',
                ori_des: [
                    {
                        origin: :A,
                        destination: :C,
                        color: :green
                    },
                    {
                        origin: :C,
                        destination: :L,
                        color: :yellow
                    },
                ]
            },
            {
                number: 3451,
                shipping: 'LA SEÑORITA',
                ori_des: [
                    {
                        origin: 'B',
                        destination: 'C',
                        color: :red
                    },
                    {
                        origin: 'C',
                        destination: 'D',
                        color: :yellow
                    },
                    {
                        origin: 'E',
                        destination: 'G',
                        color: :yellow
                    },
                ]
            },
            {
                number: 2556,
                shipping: 'CHAMAY',
                ori_des: [
                    {
                        origin: 'A',
                        destination: 'B',
                        color: :yellow
                    },
                    {
                        origin: 'B',
                        destination: 'C',
                        color: :yellow
                    },
                    {
                        origin: 'C',
                        destination: 'E',
                        color: :yellow
                    },
                ]
            },
            {
                number: 4442,
                shipping: 'KIO',
                ori_des: [
                    {
                        origin: 'A',
                        destination: 'B',
                        color: :red
                    },
                    {
                        origin: 'B',
                        destination: 'E',
                        color: :green
                    },
                ]
            },
            {
                number: 3441,
                shipping: 'DOÑA ROSITA II',
                ori_des: [
                    {
                        origin: 'A',
                        destination: 'G',
                        color: :red
                    },
                    {
                        origin: 'I',
                        destination: 'K',
                        color: :red
                    },
                    {
                        origin: 'K',
                        destination: 'L',
                        color: :red
                    },
                    {
                        origin: 'K',
                        destination: 'N',
                        color: :red
                    }
                ]
            }]
    route = [:A, :B, :C, :D, :E, :F, :G, :H, :I, :J, :K, :L, :M, :N, :O, :P, :Q, :R]
    respond_with({
                     service: list,
                     route: route
    })
  end
end