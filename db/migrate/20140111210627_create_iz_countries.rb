class CreateIzCountries < ActiveRecord::Migration
  def change
    create_table :iz_countries do |t|
      t.string :code, :limit => 2
      t.string :name, :limit => 200

      t.timestamps
    end
  end
end
