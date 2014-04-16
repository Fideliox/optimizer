class Api::V1::Maps::ShipsController < Api::ApplicationController
  def index

    render json: {result: 'OK'}
  end
end