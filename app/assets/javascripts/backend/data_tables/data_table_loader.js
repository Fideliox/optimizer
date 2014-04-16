DataTableLoader = {
    $_table_itineraries: $('#table-itineraries'),
    o_table_itineraries: null,
    $_table_demands: $('#table-demands'),
    o_table_demands: null,
    $_table_capabilities: $('#table-capabilities'),
    o_table_capabilities: null,
    $_bar: $('#bar'),
    _actual: 0,
    itineraries: function(){
        var _this = this;
        _this._actual = 0;
        _this._data_tables_itineraries();
        _this._itineraries(10, 0);
    },
    demands: function(){
        var _this = this;
        _this._actual = 0;
        _this._data_tables_demands();
        _this._demands();
    },
    capabilities: function(){
        var _this = this;
        _this._actual = 0;
        _this._data_tables_capabilities();
        _this._capabilities();
    },
    _data_tables_itineraries: function(){
        var _this = this;
        _this.o_table_itineraries = _this.$_table_itineraries.dataTable({
            'bAutoWidth': false,
            'aoColumns': [
                {'sWidth': '100px', 'sTitle': 'Viaje'},
                {'sWidth': '100px', 'sTitle': 'Ccni Code'},
                {'sWidth': '100px', 'sTitle': 'Numero Viaje'},
                {'sWidth': '100px', 'sTitle': 'Codigo Servicio'}
            ]
        });
    },
    _data_tables_demands: function(){
        var _this = this;
        _this.o_table_demands = _this.$_table_demands.dataTable({
            'bAutoWidth': false,
            'aoColumns': [
                {'sWidth': '100px', 'sTitle': 'Viaje'},
                {'sWidth': '100px', 'sTitle': 'Ccni Code'},
                {'sWidth': '100px', 'sTitle': 'Numero Viaje'},
                {'sWidth': '100px', 'sTitle': 'Codigo Servicio'}
            ]
        });
    },
    _data_tables_capabilities: function(){
        var _this = this;
        _this.o_table_demands = _this.$_table_demands.dataTable({
            'bAutoWidth': false,
            'aoColumns': [
                {'sWidth': '100px', 'sTitle': 'Viaje'},
                {'sWidth': '100px', 'sTitle': 'Ccni Code'},
                {'sWidth': '100px', 'sTitle': 'Numero Viaje'},
                {'sWidth': '100px', 'sTitle': 'Codigo Servicio'}
            ]
        });
    },
    _itineraries: function(limit, offset){
        var _url = '/api/v1/loader/itineraries/?limit=' + limit + '&offset='+ offset;
        var _this = this;
        $.get(_url, function(json){
            _this._actual = _this._actual + json.list.length;
            $.each(json.list, function(k, v){
                _this.o_table_itineraries.fnAddData([v.viaje, v.ccni_code, v.numero_viaje, v.codigo_servicio]);
            });
            var length = _this.$_bar.parent().width();

            if (_this.$_bar.width()== length) {
                $('.progress').removeClass('active');
            } else {
                _this.$_bar.width(((length * ((_this._actual * 100)/json.rows))/100));
            }
            _this.$_bar.text(((_this._actual * 100)/json.rows).toFixed(1) + "%");
            if(json.list.length>0){
                offset = offset + 10;
                _this._itineraries(10, offset)
            }
        });
    },
    _demands: function(){
        var _url = '/api/v1/loader/demands/?limit=' + limit + '&offset='+ offset;
        var _this = this;
        $.get(_url, function(json){
            _this._actual = _this._actual + json.list.length;
            $.each(json.list, function(k, v){
                _this.o_table_itineraries.fnAddData([v.viaje, v.ccni_code, v.numero_viaje, v.codigo_servicio]);
            });
            var length = _this.$_bar.parent().width();

            if (_this.$_bar.width()== length) {
                $('.progress').removeClass('active');
            } else {
                _this.$_bar.width(((length * ((_this._actual * 100)/json.rows))/100));
            }
            _this.$_bar.text(((_this._actual * 100)/json.rows).toFixed(1) + "%");
            if(json.list.length>0){
                offset = offset + 10;
                _this._itineraries(10, offset)
            }
        });
    },
    _capabilities: function(){
        var _url = '/api/v1/loader/capabilities/?limit=' + limit + '&offset='+ offset;
        var _this = this;
        $.get(_url, function(json){
            _this._actual = _this._actual + json.list.length;
            $.each(json.list, function(k, v){
                _this.o_table_itineraries.fnAddData([v.viaje, v.ccni_code, v.numero_viaje, v.codigo_servicio]);
            });
            var length = _this.$_bar.parent().width();

            if (_this.$_bar.width()== length) {
                $('.progress').removeClass('active');
            } else {
                _this.$_bar.width(((length * ((_this._actual * 100)/json.rows))/100));
            }
            _this.$_bar.text(((_this._actual * 100)/json.rows).toFixed(1) + "%");
            if(json.list.length>0){
                offset = offset + 10;
                _this._itineraries(10, offset)
            }
        });
    }
};