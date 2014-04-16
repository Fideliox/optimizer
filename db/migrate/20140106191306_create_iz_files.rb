class CreateIzFiles < ActiveRecord::Migration
  def change
    create_table :iz_files do |t|
      t.string :name
      t.references :iz_file_type, index: true
      t.boolean :activated

      t.timestamps
    end
  end
end
