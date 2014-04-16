//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap
//= require backend/data_tables/data_table_loader
//= require select/bootstrap-select.min

var CapViajes = {
    _fields: ['nave'],
    _$viajes: $('#viajes'),
    _$sel_nave: $('#nave'),
    _height: 0,
    _$modal: $('#myModal'),
    _$modal_title: $('#myModalLabel'),
    _$modal_content: $('#modal-content'),
    _$modal_btn_save: $('#btn-save'),
    _$btn_search: $('#btn-search'),
    init: function(){
        var _this = this;
        $processing_modal.modal('show');
        _this._get_filters();
        _this._bind_ships();
        _this._bind_save();
        $processing_modal.modal('hide');
    },
    _bind_save: function(){
        var _this = this;
        _this._$modal_btn_save.bind('click', function(){
            var url = '/api/v1/data_tables/update_all';
            $.getJSON(url).done(function(){
                console.log($(this));
                //_this._$sel_nave.change();
                _this._$modal.modal('hide');
            });
        });
    },
    _bind_ships: function(){
        var _this = this;
        _this._$btn_search.bind('click', function(){
            $processing_modal.modal('show');
            var url = '/api/v1/loader/cap_viajes/travels_by_ship';
            var data = '?nave=' + _this._$sel_nave.val();
            _this._height = 0;
            $.getJSON(url + data).done(function(json){
                if (json.result == 'OK'){
                    _this._$viajes.empty();
                    $.each(json.travels, function(key, value){
                        var div = $('<li />', {
                                        id: value
                                    });
                        _this._$viajes.append(div);
                        _this._div_content(value);
                    });
                }
            })
        });
    },
    _div_content: function(travel){
        var _this = this;
        var url = '/api/v1/loader/cap_viajes/routes_by_ship_travel?ship=' + _this._$sel_nave.val() + '&travel=' + travel
        var set_html = '<div><label class="title-travel"> VIAJE: ' + travel + '</label>';
        //set_html += '<button class="btn btn-primary btn-update" data-travel="'+ travel +'">Update</button></div>';
        set_html += '<table id="table-' + travel + '"  class="table" style="font-size:10px;">';
        set_html += '<tr>';
        set_html += '<th>&nbsp;</th>';
        set_html += '<th>Origin</th>';
        set_html += '<th>Destination</th>';
        set_html += '<th>Teu</th>';
        set_html += '<th>Weight</th>';
        set_html += '<th>Plugs</th>';
        set_html += '</tr>'
        $.getJSON(url).done(function(json){
            var cont = 0;
            $.each(json.route, function(key, value){
                set_html += '<tr>';
                //set_html += '<td><input type="checkbox" class="checkbox checkbox-'+ travel +'"/></td>';
                set_html += '<td>&nbsp;</td>';
                set_html += '<td>' + value.puerto_origen + '</td>';
                set_html += '<td>' + value.puerto_destino + '</td>';
                set_html += '<td>' + Utils.number_format(parseInt(value.used_teu),0, ',', '.') + ' / ' + Utils.number_format(parseInt(value.max_teu),0, ',', '.')  + '</td>';
                set_html += '<td>' + Utils.number_format(parseInt(value.used_weight),0, ',', '.')  + ' / ' + Utils.number_format(parseInt(value.max_weight),0, ',', '.')  + '</td>';
                set_html += '<td>' + Utils.number_format(parseInt(value.used_plugs),0, ',', '.')  + ' / ' + Utils.number_format(parseInt(value.max_plugs_teu),0, ',', '.')  + '</td>';
                set_html += '</tr>';
                cont++;
            });
            set_html += '</table></div>';
            var actual = cont*35;
            if (actual > _this._height){
                _this._height = actual;
                $('.box-travel').height(actual + 100);
                $processing_modal.modal('hide');
                $('body,html').stop(true,true).animate({
                    scrollTop: $('#viajes').offset().top
                },1000);
            }
            $('#' + travel).html(set_html);
            $('.btn-update').unbind('click');
            $('.btn-update').bind('click', function(){
                var $this = $(this);
                var travel =  $this.data('travel');
                var ports = '';
                _this._$modal.modal('show');
                _this._$modal_title.text('Travel: ' + travel);
                $('.checkbox-'+ travel).each(function(){
                    if ($(this).is(":checked")) {
                        var pori = $(this).first().parent().parent().children().next().first().text();
                        var pdes = $(this).first().parent().parent().children().next().next().first().text();
                        ports += pori + '/' + pdes + '  ';
                    }
                });
                _this._$modal_content.html(ports);
            });
        });
    },
    _get_filters: function(){
        var _this = this;
        var url = '/api/v1/loader/cap_viajes/unq_cap';
        $.each(_this._fields, function(k, v){
            var data = '?field=' + v;
            var $select = $('#' + v);
            $.getJSON(url + data, function(json){
                $select.append("<option value=''>- Select ship -</option>");
                $.each(json.list, function(key, value){
                    $select.append("<option value='" + value + "'>" + value + "</option>");
                });
            });

        });
    }
};