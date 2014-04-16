module DataGridHelper
  def dg_references(field)
    if field != 'unique_id'
      prefix = field[(field.length-1 - 2) .. field.length - 1]
      value = false
      if prefix == '_id'
        field = field[0 .. (field.length-1 - 2) - field.length - 1]
        value = field
      end
    end
    value
  end

  def get_format format, field, value
    if format[:date]
      if format[:date][field.to_sym]
        value = value.strftime(format[:date][field.to_sym])
      end
    end if value
    value
  end

  def get_open_link(open_link, field, value)
    open_link ? open_link[field.to_sym] : self.a(value) ? value : value
  end

  def a(value)
    content_tag :a, value, class: '.open_link', href: '#'
  end

  def input_type model, column, dataset
    references = dg_references column.name
    select = ''
    select = eval("#{references.camelize}").all.pluck(:name, :id) if references
    if select.length == 0
      case column.type.to_s
        when 'string'
          input = text_field_tag column.name.to_sym, !dataset ? nil : dataset[column.name.to_sym] , name: "#{model}[#{column.name}]", autocomplete: "off", :class => 'form-control'
        when 'integer'
          input = number_field_tag column.name.to_sym, !dataset ? nil : dataset[column.name.to_sym] , name: "#{model}[#{column.name}]", autocomplete: "off", :class => 'form-control'
        when 'boolean'
          input = check_box_tag column.name.to_sym, '1', !dataset ? nil : dataset[column.name.to_sym], :class => 'form-control'
        else
          input = ''
      end
    else
        input = select_tag(column.name.to_sym, options_for_select(select, !dataset ? nil : dataset[column.name.to_sym]), name: "#{model}[#{column.name}]", :class => "form-control")
    end
    input
  end


end
