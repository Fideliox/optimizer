class CreateIzPolyLines < ActiveRecord::Migration
  def change
    create_table :iz_poly_lines do |t|
      t.integer :ori
      t.integer :des
      t.text :coo

      t.timestamps
    end
  end
end
