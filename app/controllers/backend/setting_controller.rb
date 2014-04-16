class Backend::SettingController < ApplicationController
  def index
    @socket_ip, @socket_port = Setting.socket()
    @postgresql_ip, @postgresql_user, @postgresql_password, @postgresql_dbname, @postgresql_port = Setting.postgresql()
    @rds_ip, @rds_user, @rds_password, @rds_dbname, @rds_port = Setting.rds()
  end
  def icons

  end
  def iframe
  	
  end
end
