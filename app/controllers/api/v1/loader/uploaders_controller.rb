class Api::V1::Loader::UploadersController < Api::ApplicationController
  def list
    iz_file_type_ids = params[:type_id].split(",")
    list = Iz::File.where('iz_file_type_id in (?)', iz_file_type_ids)
    render json: {list: list}
  end
end