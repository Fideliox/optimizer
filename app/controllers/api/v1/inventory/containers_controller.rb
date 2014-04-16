class Api::V1::Inventory::ContainersController < Api::ApplicationController
  def index
    types = Array.new
    containers = ["20''", "40''", "40'' HQ", "40'' Ref"].shuffle
    containers.each do |n|
      types << {
        name: n.to_str,
        teu: in_out,
        leg: in_out,
        net: in_out
      }
    end
    total = {
        teu: sum_in_out(types, 'teu'),
        leg: sum_in_out(types, 'leg'),
        net: sum_in_out(types, 'net'),
    }
    # Response
    respond_with({
        containers: {
            types: types,
            total: total
        }
    })
  end

  private
  def sum_in_out(types, i)
    s_in = 0
    s_out = 0
    types.each { |a|
      s_in+=a[i.to_sym][:in].to_i
      s_out+=a[i.to_sym][:len].to_i
    }
    if i != 'teu'
      s_in =  (s_in.to_f / 1000).round(2)
      s_out =  (s_out.to_f / 1000).round(2)
    end
    { in: s_in, len: s_out }
  end
  def in_out
    min = Random.rand(5000)
    max = Random.rand(5000)
    if min > max
      aux = max
      max = min
      min = aux
    end
    { in: min , len: max }
  end
end
