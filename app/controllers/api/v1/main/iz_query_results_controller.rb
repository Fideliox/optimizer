class Api::V1::Main::IzQueryResultsController < Api::ApplicationController
  def group_demand
    data = []
    list = Inzpiral::QueryResults.select("split_part(\"ProcessDescription\", ' on: ', 1)").group("split_part(\"ProcessDescription\", ' on: ', 1)")
    list.each do |l|
      data << {
          demand: l.split_part
      }
    end
    render json: { demand: data }
  end
  def index
    data = []
    list = Inzpiral::QueryResults.all.limit(40)
    list.each do |l|
      on_leg = l.ProcessDescription.split('on:')[1].split(' off: ')[0]
      off_leg = l.ProcessDescription.split('off:')[1]
      transito = ""
      if on_leg.split(":")[2] != off_leg.split(":")[2]  then
        transito = "T"
      end
      material = l.Material.split(":")
      fecha = material[0]
      container = material[1]
      container_op = material[2]
      origen_carga_red = material[3]
      destino_carga_red = material[4]
      servicio_nave_inicial = material[5]
      nave_inicial = material[6]
      sentido_nave_inicial = material[7]
      numero_viaje_nave_inicial = material[8]
      directo = material[9]
      commodity = material[10]
      cliente = material[11]
      contrato = material[12]
      origen_carga_off_line = material[13]
      detino_carga_off_line = material[14]

      rate = material[material.length - 1]
      data << {
          demand: l.ProcessDescription.split(' on: ')[0],
          on_leg: on_leg,
          off_leg: off_leg,
          transito: transito,
          date: fecha,
          container: container,
          rate: rate,
          container_op: container_op,
          origen_carga_red: origen_carga_red,
          destino_carga_red: destino_carga_red,
          servicio_nave_inicial: servicio_nave_inicial,
          nave_inicial: nave_inicial,
          sentido_nave_inicial: sentido_nave_inicial,
          numero_viaje_nave_inicial: numero_viaje_nave_inicial,
          directo: directo,
          commodity: commodity,
          cliente: cliente,
          contrato: contrato,
          origen_carga_off_line: origen_carga_off_line,
          detino_carga_off_line: detino_carga_off_line,
          ObjectName: l.ObjectName,
          FromLocation: l.FromLocation,
          ToLocation: l.ToLocation,
          SolutionUnits: l.SolutionUnits,
          CostPerUnit: l.CostPerUnit,
          SolutionUnits1: l.SolutionUnits1,
          CostPerUnit1: l.CostPerUnit1,
          ObjectName1: l.ObjectName1,
          id: l.id
      }
    end
    render json: { list: data }
  end
end