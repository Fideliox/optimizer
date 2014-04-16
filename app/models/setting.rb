class Setting < ActiveRecord::Base
  def self.socket
    setting = Setting.where(key: 'socket_ip').first
    socket_ip = setting ? setting.value : ''
    setting = Setting.where(key: 'socket_port').first
    socket_port = setting ? setting.value : ''
    return socket_ip, socket_port
  end
  def self.postgresql
    setting = Setting.where(key: 'postgresql_ip').first
    postgresql_ip = setting ? setting.value : ''
    setting = Setting.where(key: 'postgresql_user').first
    postgresql_user = setting ? setting.value : ''
    setting = Setting.where(key: 'postgresql_dbname').first
    postgresql_dbname = setting ? setting.value : ''
    setting = Setting.where(key: 'postgresql_port').first
    postgresql_port = setting ? setting.value : ''
    return postgresql_ip, postgresql_user, '', postgresql_dbname, postgresql_port
  end
  def self.rds
    setting = Setting.where(key: 'rds_ip').first
    rds_ip = setting ? setting.value : ''
    setting = Setting.where(key: 'rds_user').first
    rds_user = setting ? setting.value : ''
    setting = Setting.where(key: 'rds_dbname').first
    rds_dbname = setting ? setting.value : ''
    setting = Setting.where(key: 'rds_port').first
    rds_port = setting ? setting.value : ''
    return rds_ip, rds_user, '', rds_dbname, rds_port
  end
end
