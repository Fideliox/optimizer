class Api::V1::SettingsController < Api::ApplicationController
  def create
    if params[:postgresql_ip]
      Setting.delete_all(key: 'postgresql_ip')
      Setting.create(key: 'postgresql_ip', value: params[:postgresql_ip].gsub(/\s+/, ""))
    end
    if params[:postgresql_user]
      Setting.delete_all(key: 'postgresql_user')
      Setting.create(key: 'postgresql_user', value: params[:postgresql_user].gsub(/\s+/, ""))
    end
    if params[:postgresql_password]
      Setting.delete_all(key: 'postgresql_password') if params[:postgresql_password].gsub(/\s+/, "") != ''
      Setting.create(key: 'postgresql_password', value: params[:postgresql_password].gsub(/\s+/, "")) if params[:postgresql_password].gsub(/\s+/, "") != ''
    end
    if params[:postgresql_dbname]
      Setting.delete_all(key: 'postgresql_dbname')
      Setting.create(key: 'postgresql_dbname', value: params[:postgresql_dbname].gsub(/\s+/, ""))
    end
    if params[:postgresql_port]
      Setting.delete_all(key: 'postgresql_port')
      Setting.create(key: 'postgresql_port', value: params[:postgresql_port].gsub(/\s+/, ""))
    end
    if params[:rds_ip]
      Setting.delete_all(key: 'rds_ip')
      Setting.create(key: 'rds_ip', value: params[:rds_ip].gsub(/\s+/, ""))
    end
    if params[:rds_user]
      Setting.delete_all(key: 'rds_user')
      Setting.create(key: 'rds_user', value: params[:rds_user].gsub(/\s+/, ""))
    end
    if params[:rds_password]
      Setting.delete_all(key: 'rds_password') if params[:rds_password].gsub(/\s+/, "") != ''
      Setting.create(key: 'rds_password', value: params[:rds_password].gsub(/\s+/, "")) if params[:rds_password].gsub(/\s+/, "") != ''
    end
    if params[:rds_dbname]
      Setting.delete_all(key: 'rds_dbname')
      Setting.create(key: 'rds_dbname', value: params[:rds_dbname].gsub(/\s+/, ""))
    end
    if params[:rds_port]
      Setting.delete_all(key: 'rds_port')
      Setting.create(key: 'rds_port', value: params[:rds_port].gsub(/\s+/, ""))
    end
    if params[:socket_ip]
      Setting.delete_all(key: 'socket_ip')
      Setting.create(key: 'socket_ip', value: params[:socket_ip].gsub(/\s+/, ""))
    end
    if params[:socket_port]
      Setting.delete_all(key: 'socket_port')
      Setting.create(key: 'socket_port', value: params[:socket_port].gsub(/\s+/, ""))
    end
    render json: {
        result: 'OK'
    }
  end
end