class Backend::Loader::UploadersController < ApplicationController
  def index

  end

  def file
    output_file = Iz::File.where(id: params[:id]).first.name
    send_file(
        "#{Rails.root}/../../files/" + output_file,
        filename: output_file,
        type: "text/csv"
    )
  end

  def log
    send_file(
        "/tmp/karguroo.log",
        filename: 'karguroo.log',
        type: "text/plain"
    )
  end
end
