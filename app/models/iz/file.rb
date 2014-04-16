class Iz::File < ActiveRecord::Base
  belongs_to :iz_file_type, :class_name => 'Iz::FileType'
  def self.upload_csv(filecsv = '')
    filename = Rails.root.join('../../files', filecsv.original_filename.gsub(' ', '.'))
    File.open(filename, 'wb') do |file|
      file.write(filecsv.read)
    end
  end

  def self.bulk_csv(id)
    row = self.where(id: id).first
    type = row.iz_file_type.code
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join("config","config.yml")))
    py = config[:default][:python][type.to_sym][:import]
    script = Rails.root.join('python', py)
    file = Rails.root.join('../../files', row.name)
    Rails.logger.info script
    Rails.logger.info file
    system('python ' + script.to_s + ' ' + file.to_s + ' &')
  end

  def self.read_log(file, filename)
    filename_log = '/tmp/'+ file +'.log'
    File.unlink(filename_log) if File.exists?(filename_log)
    script = Rails.root.join('python', 'validate', file + '.py')
    filename = Rails.root.join('../../files', filename)
    Rails.logger.info('python ' + script.to_s + ' ' + filename.to_s + ' > ' + filename_log.to_s)
    system('python ' + script.to_s + ' ' +  filename.to_s + ' > ' + filename_log.to_s)
    file = File.open(filename_log, 'r')
    data = ''
    while (line = file.gets)
      data += "#{line}<br />"
    end
    file.close
    data
  end
end
