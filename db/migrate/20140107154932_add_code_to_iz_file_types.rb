class AddCodeToIzFileTypes < ActiveRecord::Migration
  def change
    add_column :iz_file_types, :code, :string
  end
end
