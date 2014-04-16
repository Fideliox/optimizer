class Api::V1::Process::IzFilesController < Api::ApplicationController
  def index
    status = 'OK'
    if (!params[:start_date].has_key? or !params[:end_date].has_key?)
      status = 'FAIL'
    end
    Inzpiral::EmptyOd.export_excel(params['start_date'].to_date.strftime('%Y%m%d') , params['end_date'].to_date.strftime('%Y%m%d'))
    render json: {status: status}
  end

  def status
    status = 'OK'
    cap = 100
    dem = 100
    iti = 100
    cos = 100
    sto = 100
    ierror = true
    derror = true
    cerror = true
    coerror = true
    serror = true
    itinerario = Iz::StatusPython.where(process: 'loader_itinerarios').first
    if !!itinerario
      if itinerario.total > 0
        iti = (itinerario.actual * 100 ) / itinerario.total
        ierror = false
      end
    end
    demandas = Iz::StatusPython.where(process: 'loader_demandas').first
    if !!demandas
      if demandas.total > 0
        dem = (demandas.actual * 100 ) / demandas.total
        derror = false
      end
    end
    capacidades = Iz::StatusPython.where(process: 'loader_capacidades').first
    if !!capacidades
      if capacidades.total > 0
        cap = (capacidades.actual * 100 ) / capacidades.total
        cerror = false
      end
    end
    costos = Iz::StatusPython.where(process: 'loader_costos').first
    if !!costos
      if costos.total > 0
        cos = (costos.actual * 100 ) / costos.total
        coerror = false
      end
    end
    stocks = Iz::StatusPython.where(process: 'loader_inventario_contenedores').first
    if !!stocks
      if stocks.total > 0
        sto = (stocks.actual * 100 ) / stocks.total
        serror = false
      end
    end
    render json: {
        result: 'OK',
        status: {
            itineraries: {
                percentage: iti,
                filename: itinerario ? itinerario.filename ? itinerario.filename.split('/').pop : '' : '',
                error: ierror
            },
            demands: {
                percentage: dem,
                filename: demandas ? demandas.filename ? demandas.filename.split('/').pop : '' : '',
                error: derror
            },
            capabilities: {
                percentage: cap,
                filename: capacidades ? capacidades.filename ? capacidades.filename.split('/').pop : '' : '',
                error: cerror
            },
            costs: {
                percentage: cos,
                filename: costos ? costos.filename ? costos.filename.split('/').pop : '' : '',
                error: coerror
            },
            stocks: {
                percentage: sto,
                filename: stocks ? stocks.filename ? stocks.filename.split('/').pop : '' : '',
                error: serror
            }
        }
    }
  end
  def reload_csv
    Iz::File.bulk_csv(params[:id])
    render json: { status: 'OK' }
  end
  def read_log
    log = ''
    file_type = Iz::FileType.where(id: params[:file]).first
    file = Iz::File.where(id: params[:id]).first
    log = Iz::File.read_log(file_type.name, file.name) if file_type
    render text: log
  end
  def status_xlsx
    status = Iz::StatusPython.where(process: params[:process]).first
    Rails.logger.info params[:process]
    render status: 200,
           json: {
               actual: status.actual,
               total: status.total,
               percentage: (status.actual * 100) / status.total
           }
  end
end