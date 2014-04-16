class Api::V1::Main::IzFilesController < Api::ApplicationController
  def create
    begin
      rs = Iz::File.create({
                            name: params[:name].gsub(' ', '.'),
                            iz_file_type_id: params[:iz_file_type_id]
                            })
      render json: {
          status: 'OK',
          id: rs.id,
          name: rs.name,
          iz_file_type_id: rs.iz_file_type_id
      }
    rescue Exception => e
      render json: { status: 'FAIL'}
    end
  end
  def destroy
    begin
      Iz::File.destroy(params[:id])
      render json: { status: 'OK'}
    rescue Exception => e
      render json: { status: 'FAIL'}
    end
  end

  def list
    begin
      iz_file_type_ids = params[:type_id].split(",")
      list = Iz::File.where('iz_file_type_id in (?)', iz_file_type_ids)
      render json: {list: list}
    rescue Exception => e
      render json: { status: e}
    end
  end

  def upload_csv
      file = params[:uploader_i] if params[:uploader_i]
      file = params[:uploader_d] if params[:uploader_d]
      file = params[:uploader_c] if params[:uploader_c]
      file = params[:uploader_co] if params[:uploader_co]
      file = params[:uploader_s] if params[:uploader_s]
      Iz::File.upload_csv(file)
      render json: { status: 'OK' }
  end

end