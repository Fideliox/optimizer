class Backend::Main::RboUsersController < Backend::Main::BaseController
  include DataGridHelper
  before_filter :ignore_fields

  def ignore_fields
    @ignore = [:id.to_s,
               :password.to_s,
               :updated_at.to_s,
               :created_at.to_s,
               :online.to_s,
               :access.to_s,
               :salt.to_s,
               :encrypted_password.to_s,
               :reset_password.to_s,
               :reset_password_token.to_s,
               :reset_password_sent_at.to_s,
               :remember_created_at.to_s,
               :sign_in_count.to_s,
               :current_sign_in.to_s,
               :current_sign_in_at.to_s,
               :current_sign_ip.to_s,
               :current_sign_in_ip.to_s,
               :current_sign_ip_at.to_s,
               :last_sign_in_at.to_s,
               :last_sign_in_ip.to_s,
               :last_sign_in_ip_at.to_s
    ]
  end
  def index
    @data_grid = {
        dataset: RboUser.order(:name),
        model: RboUser,
        options: { edit: true, delete: true, show: true},
        format: {
            date: {
                created_at: "%d/%m/%Y"
            }
        },
        ignore: @ignore - [:created_at.to_s]
    }
  end

  def new
    @data_grid = {
        model: RboUser,
        ignore: @ignore - [:password.to_s]
    }
    render :partial => "shared/data_grid/new"
  end

  def create
    begin
      rbo_user = RboUser.new({
                        name: params[:name],
                        username: params[:username],
                        email: params[:email],
                        signature: params[:signature],
                        rbo_role_id: params[:rbo_role_id],
                        password: params[:password],
                        activated: params[:activated]
                      })
      params[:status] = rbo_user.save ? true:false
      params[:id] = rbo_user.id
      params[:rbo_role_id] = rbo_user.rbo_role.name
      params[:created_at] = rbo_user.created_at.strftime("%d/%m/%Y") if rbo_user.created_at
    rescue Exception => e
      params[:errors] = e
    end
    render :json => params
  end

  def show
    @data_grid = {
        dataset: RboUser.find(params[:id]),
        model: RboUser,
        ignore: @ignore
    }
    render :partial => "shared/data_grid/show"
  end

  def edit
    @data_grid = {
        dataset: RboUser.find(params[:id]),
        model: RboUser,
        ignore: @ignore - [:password.to_s]
    }
    render :partial => "shared/data_grid/edit"
  end

  def update
    begin
      rbo_user = RboUser.find(params[:id])
      rbo_user.name = params[:name]
      rbo_user.username = params[:username]
      rbo_user.email =  params[:email]
      rbo_user.signature = params[:signature]
      rbo_user.rbo_role_id = params[:rbo_role_id]
      rbo_user.password = params[:password]
      rbo_user.activated = params[:activated]
      params[:status] = rbo_user.save ? true:false
      params[:id] = rbo_user.id
      params[:created_at] = rbo_user.created_at.strftime("%d/%m/%Y") if rbo_user.created_at
    rescue Exception => e
      params[:errors] = e
    end
    render :json => params
  end

  def destroy
    begin
      params[:status] = RboUser.delete(params[:id]) ? true:false
    rescue Exception => e
      params[:errors] = e
    end
    render :json => params
  end

  def destroy_session

  end

end
