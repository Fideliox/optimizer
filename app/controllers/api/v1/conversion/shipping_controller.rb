class Api::V1::Conversion::ShippingController < Api::ApplicationController
  def index
    list = [{name: 'PINCOLLA'},
                {name:  'CALEUCHE'},
                {name: 'LA SEÑORITA'},
                {name: 'DON PEPE'},
                {name: 'EL TRAUCO'},
                {name: 'DOÑA ROSITA II'}]
    respond_with({
      shipping: list
    })
  end
end