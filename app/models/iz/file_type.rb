class Iz::FileType < ActiveRecord::Base
  has_many :iz_files, :class_name => 'Iz::File'
end
