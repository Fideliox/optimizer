class Backend::Main::RolesController < Backend::Main::BaseController
  include DataGridHelper
  def index
    @data_grid = {
        dataset: RboRole.order(:name),
        model: RboRole,
        options: { edit: true, delete: true, show: true},
        format: {
            date: {
                created_at: "%d/%m/%Y"
            }
        },
        order: ['name', 'open_path', 'activated'],
        ignore: ['id', 'updated_at', 'created_at']
    }
  end

  def new
    @data_grid = {
        model: RboRole,
        ignore: ['id', 'updated_at', 'created_at']
    }
    render :partial => "shared/data_grid/new"
  end

  def create
    begin
      rbo_role = RboRole.create({name: params[:name], activated: params[:activated], open_path: params[:open_path]})
      params[:status] = rbo_role ? true:false
      params[:errors] = rbo_role.errors
      params[:id] = rbo_role.id
      params[:created_at] = rbo_role.created_at.strftime("%d/%m/%Y")
    rescue Exception => e
      params[:errors] = e
    end
    render :json => params
  end

  def show
    @data_grid = {
        dataset: RboRole.find(params[:id]),
        model: RboRole,
        ignore: ['id', 'updated_at', 'created_at']
    }
    render :partial => "shared/data_grid/show"
  end

  def edit
    @data_grid = {
        dataset: RboRole.find(params[:id]),
        model: RboRole,
        ignore: ['id', 'updated_at', 'created_at']
    }
    render :partial => "shared/data_grid/edit"
  end

  def update
    begin
      rbo_role = RboRole.find(params[:id])
      rbo_role.name = params[:name]
      rbo_role.activated = params[:activated]
      rbo_role.open_path = params[:open_path]
      params[:status] = rbo_role.save ? true:false
      params[:id] = rbo_role.id
      params[:created_at] = rbo_role.created_at.strftime("%d/%m/%Y") if rbo_role.created_at
    rescue Exception => e
      params[:errors] = e
    end
    render :json => params
  end

  def destroy
    begin
      params[:status] = RboRole.delete(params[:id]) ? true:false
    rescue Exception => e
      params[:errors] = e
    end
    render :json => params
  end

end
