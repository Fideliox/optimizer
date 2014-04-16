class Api::V1::Main::RolesController < Api::ApplicationController
  def index
    roles = RboRole.all.order(:name)
    list = []
    roles.each{|r|
      list << {
          id: r.id,
          name: r.name,
          open_path: r.open_path,
          created_at: r.created_at,
          activated: r.activated
      }
    }
    render status: 200,
           json: { roles: list }
  end
end