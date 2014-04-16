class Api::V1::Process::SocketController < Api::ApplicationController
  def execute
    code = []
    case params[:id].to_i
      when 1000 # execute all
        code = [1000]
      when 2 #solve model
        code = [400, 500, 555, 550, 600]
      when 3 #Generate routes
        code = [200, 250]
      when 4 #Generate port, stock, vessel, leg capacities and port restrictions
        code = [100]
      when 5 #Process demand
        code = [300]
      when 6 #Populate empty
        code = [350]
      when 7 # solve model
        code = [400]
      when 8 # Export Result
        code = [500]
      when 9 # stop all
        code = [9]
      when 10 # Backup DB
        code = [550, 600]
    end
    server, port = Setting.socket()
    Socket.tcp(server, port){|s|
      code.each{|c|
        s.print c
      }
      s.close_write
    }
    render status: 200,
           json: { result: 'OK' }
  end

  def eo
    begin
      @postgresql_ip, @postgresql_user, @postgresql_password, @postgresql_dbname, @postgresql_port = Setting.postgresql()
      Timeout.timeout(5) do
        puts @postgresql_ip
        s = Socket.tcp(@postgresql_ip, 5432)
        s.close
        render json: { status: true }
      end
    rescue => detail
      render json: { status: false }
    end
  end

  def vb
    begin
      server, port = Setting.socket()
      Timeout.timeout(5) do
        puts server
        s = Socket.tcp(server, port.to_i)
        s.close
        render json: { status: true }
      end
    rescue => detail
      render json: { status: false }
    end
  end

  def ping
    begin
      host = params[:host]
      port = params[:port] if params[:port]
      Timeout.timeout(5) do
        if params[:port]
          s = Socket.tcp(host, port)
        else
          s = Socket.tcp(host, 5432)
        end
        s.close
        render json: { status: true }
      end
    rescue => detail
      render json: { status: false }
    end
  end
end