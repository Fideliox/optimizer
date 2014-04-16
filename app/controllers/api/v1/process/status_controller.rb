class Api::V1::Process::StatusController < Api::ApplicationController
  def index
    loader_master_shipments = 0
    loader_empty_containers = 0
    set_distance = 0
    rutas_factibles = []
    solve = 0
    export = 0
    stock = 0
    init_model = 0
    if  s = Iz::StatusPython.status('loader_master_shipments').first
      loader_master_shipments = s['porcentaje']
    end
    if  s = Iz::StatusPython.status('loader_empty_containers').first
      loader_empty_containers = s['porcentaje']
    end
    if  s = Iz::StatusPython.status('set_distance').first
      set_distance = s['porcentaje']
    end
    if  s = Iz::StatusPython.status('eo').first
      solve = s['porcentaje']
    end
    if  s = Iz::StatusPython.status('export').first
      export = s['porcentaje']
    end
    if  s = Iz::StatusPython.status('stock').first
      stock = s['porcentaje']
    end
    if  s = Iz::StatusPython.status('init_model').first
      init_model = s['porcentaje']
    end
    if  s = Iz::StatusPython.status('FINDROUTE').first
      rutas_factibles << {
          porcentaje: s['porcentaje'].to_i,
          actual: s['actual'].to_i,
          limite: s['limite'].to_i
      }
    end
    render status: 200,
           json: {
               loader_master_shipments: loader_master_shipments.to_i,
               loader_empty_containers: loader_empty_containers.to_i,
               set_distance: set_distance.to_i,
               solve: 0,
               rutas_factibles: rutas_factibles,
               solve: solve.to_i,
               export: export.to_i,
               stock: stock.to_i,
               init_model: init_model.to_i
           }
  end
end