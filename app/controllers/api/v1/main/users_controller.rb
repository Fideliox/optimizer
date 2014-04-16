class Api::V1::Main::UsersController < Api::ApplicationController
  def index
    users = RboUser.all.order(:name)
    list = []
    users.each{|u|
      list << {
          id: u.id,
          name: u.name,
          email: u.email,
          created_at: u.created_at,
          activated: u.activated
      }
    }
    render json: {
        result: 'OK',
        users: list
    }
  end
end