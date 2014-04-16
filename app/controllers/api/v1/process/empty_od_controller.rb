class Api::V1::Process::EmptyOdController < Api::ApplicationController
  def status_xlsx
    status = Iz::StatusPython.where(process: params[:process]).first
    Rails.logger.info params[:process]
    render status: 200,
           json: {
               actual: status.actual,
               total: status.total,
               percentage: (status.actual * 100) / status.total
           }
  end
end