class CreateIzFileTypes < ActiveRecord::Migration
  def change
    create_table :iz_file_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
