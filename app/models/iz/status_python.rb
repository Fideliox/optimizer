class Iz::StatusPython < ActiveRecord::Base
  self.table_name = 'iz_status_python'
  def self.status(process)
    begin
      query = "SELECT ((sum(actual) * 100) / sum(limite)) porcentaje, round(avg(actual)) actual, round(avg(limite)) limite FROM iz_status_python
              WHERE process  = '#{process}'
              GROUP BY process"
      ActiveRecord::Base.connection.execute(query)
    rescue => detail
      [{:porcentaje.to_s => 0}, {:actual.to_s => 0}, {:limite.to_s => 0}]
    end
  end
  def self.status_old(process)
    begin
      query = "SELECT ((sum(actual) * 100) / sum(total)) porcentaje FROM iz_status_python
            WHERE split_part(process, ':', 1)  = '#{process}'
            GROUP BY split_part(process, ':', 1)"
      ActiveRecord::Base.connection.execute(query)
    rescue => detail
      [{:porcentaje.to_s => 0}]
    end
  end
end