class DistanceAddToIzPolyLines < ActiveRecord::Migration
  def change
    add_column :iz_poly_lines, :distance, :string
  end
end
