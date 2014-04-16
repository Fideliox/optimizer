class Iz::CapacityResult < ActiveRecord::Base
  def result
    query = "select * from iz_capacity_results"
  end
end