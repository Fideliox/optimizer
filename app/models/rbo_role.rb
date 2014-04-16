class RboRole < ActiveRecord::Base
  has_many :rbo_down_menu
  has_many :rbo_user
end
