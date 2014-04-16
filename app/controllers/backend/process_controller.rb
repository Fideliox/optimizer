class Backend::ProcessController < ApplicationController
  def index

  end
  def routes
    items = Cargador::RutasFactibles.no_routes()
    respond_to do |format|
      format.xlsx { send_file Rails.root.join('../../files', 'no_routes.xlsx'),
                              filename: 'no_routes.xlsx',
                              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
    end
  end
end