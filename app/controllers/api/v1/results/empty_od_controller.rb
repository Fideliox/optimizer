class Api::V1::Results::EmptyOdController < Api::ApplicationController
  def empty_xlsx
    Iz::EmptyOd.generate_xlsx
    render status: 200,
           json: { result: 'OK' }
  end
end