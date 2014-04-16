class Backend::ResultsController < ApplicationController
  def index

  end
  def empty
    respond_to do |format|
      format.xlsx { send_file Rails.root.join('../../files', 'empty.xlsx'),
                              filename: 'empty.xlsx',
                              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
    end
  end
  def demand
    @out_demand = Cargador::Demanda.out_demand
    respond_to do |format|
      format.xlsx { send_file Rails.root.join('../../files', 'demands.xlsx'),
                              filename: 'demandas.xlsx',
                              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
      format.csv { send_data @out_demand.to_csv }
      format.xls
    end
  end

  def loader_itinerary
    @out_data = Cargador::Itinerario.out_data
    respond_to do |format|
      format.html
      format.csv { send_data @out_data.to_csv }
      format.xls
    end
  end

  def loader_demand
    @out_data = Cargador::Demanda.out_data
    respond_to do |format|
      format.html
      format.csv { send_data @out_data.to_csv }
      format.xls
    end
  end

  def loader_capacity
    @out_data = Cargador::Capacidad.out_data
    respond_to do |format|
      format.html
      format.csv { send_data @out_data.to_csv }
      format.xls
    end
  end

  def loader_cost
    @out_data = Cargador::Cost.out_data
    respond_to do |format|
      format.html
      format.csv { send_data @out_data.to_csv }
      format.xls
    end
  end

  def loader_inventory_container
    @out_data = Cargador::InventoryContainer.out_data
    respond_to do |format|
      format.html
      format.csv { send_data @out_data.to_csv }
      format.xls
    end
  end

  def iz_dda_final_detail
    @out_data = Iz::DdaFinalResultsDetail.out_data
    respond_to do |format|
      format.html
      format.csv { send_data @out_data.to_csv }
      format.xls
    end
  end
end
