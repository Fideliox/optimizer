class Api::V1::Purchase::ActivityMtpController < Api::ApplicationController
  def get_top_10
    sql = "SELECT \"Location\",
           \"ItemDescription\",
           \"MaxUnits\",
           \"SolutionUnits\",
           (\"MaxUnits\" - \"SolutionUnits\") AS TEU_no_aceptados
            /* \"ObjectName\" */
    FROM eo_purchase_purchase_activity_mtp
    WHERE \"ObjectName\" LIKE 'SendShipment'
    ORDER BY TEU_no_aceptados DESC
    LIMIT 10"
    list = ActiveRecord::Base.connection.execute(sql)

    # Response
    render json: list
    #respond_with({ list: list })
  end
end