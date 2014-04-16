class Iz::ListPort < ActiveRecord::Base
  belongs_to :iz_country, :class_name => 'Iz::Country'
end
