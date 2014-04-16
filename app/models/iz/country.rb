class Iz::Country < ActiveRecord::Base
  has_many :iz_list_ports, :class_name => 'Iz::ListPort'
end
