//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap
//= require backend/data_tables/data_table_loader
//= require select/bootstrap-select.min

var Demands = {
    _$table_demands: $('#table-demands'),
    _$btn_search: $('#btn-search'),
    _$selectpicker: $('.selectpicker'),
    _url: '/api/v1/loader/demands/filter',
    _fields: ['servicio1', 'sentido1', 'nave1', 'viaje1', 'por_onu', 'pol_onu', 'podl_onu', 'direct_ts', 'item_type', 'cnt_type_iso', 'comm_name', 'issuer_name', 'customer_type'],
    init: function(){
        var _this = this;
        _this._object_tables();
        //_this._object_select();
        _this._get_filters();
        _this._bind_search();
        _this._bind_select();
    },
    _object_select: function(){
        var _this = this;
        _this._$selectpicker.selectpicker({
            'selectedText': 'cat'
        });
    },
    _get_filters: function(){
        var _this = this;
        var url = '/api/v1/loader/demands/unique';
        $.each(_this._fields, function(k, v){
            var data = '?field=' + v;
            var $select = $('#' + v);
            $.getJSON(url + data, function(json){
                $.each(json.data, function(key, value){
                    $select.append("<option value='" + value + "'>" + value + "</option>");
                });
                $select.selectpicker({
                    'selectedText': 'cat'
                });
            })
        });
    },
    _object_tables: function(){
        var _this = this;
        _this.o_table = _this._$table_demands.dataTable({
            'bAutoWidth': false,
            'aoColumns': [
                {'sWidth': '100px', 'sTitle': 'servicio1'},
                {'sWidth': '100px', 'sTitle': 'sentido1'},
                {'sWidth': '100px', 'sTitle': 'nave1'},
                {'sWidth': '100px', 'sTitle': 'viaje1'},
                {'sWidth': '100px', 'sTitle': 'por_onu'},
                {'sWidth': '100px', 'sTitle': 'pol_onu'},
                {'sWidth': '100px', 'sTitle': 'podl_onu'},
                {'sWidth': '100px', 'sTitle': 'direct_ts'},
                {'sWidth': '100px', 'sTitle': 'item_type'},
                {'sWidth': '100px', 'sTitle': 'cnt_type_iso'},
                {'sWidth': '100px', 'sTitle': 'comm_name'},
                {'sWidth': '100px', 'sTitle': 'issuer_name'},
                {'sWidth': '100px', 'sTitle': 'customer_type'},
                {'sWidth': '100px', 'sTitle': 'cantidad'},
                {'sWidth': '100px', 'sTitle': 'freight_tons_un'},
                {'sWidth': '100px', 'sTitle': 'weight_un'},
                {'sWidth': '100px', 'sTitle': 'teus'},
                {'sWidth': '100px', 'sTitle': 'lost_teus'},
                {'sWidth': '100px', 'sTitle': 'flete_all_in_us_un'},
                {'sWidth': '100px', 'sTitle': 'other_cost'},
                {'sWidth': '100px', 'sTitle': 'peso'},
                {'sWidth': '100px', 'sTitle': 'cost_per_teu'},
                {'sWidth': '100px', 'sTitle': 'accept'},
                {'sWidth': '100px', 'sTitle': 'no_accept'}
            ]
        });
    },
    _bind_search: function(){
        var _this = this;
        _this._$btn_search.bind('click', function(){
            $.getJSON(_this._url, function(json){
                $.each(json.demands, function(k, v){
                    _this.o_table.fnAddData([v.servicio1, v.sentido1, v.nave1, v.viaje1, v.por_onu, v.pol_onu, v.podl_onu, v.direct_ts, v.item_type, v.cnt_type_iso, v.comm_name, v.issuer_name, v.customer_type, v.cantidad, v.freight_tons_un, v.weight_un, v.teus, v.lost_teus, v.flete_all_in_us_un, v.other_cost, v.peso, v.cost_per_teu, v.accept, v.no_accept]);
                });
            });
        });
    },
    _bind_select: function(){
        var _this = this;
        _this._$selectpicker.bind('change', function(){
            $this = $(this);
            var id = $this.attr('id');
            _this._fields[id] = [];
           if(!!$this.val()){
               var str = id + ',' + $this.val();
               _this._fields[id].push($this.val());
/*
               var url = '/api/v1/loader/demands/unique';
               var fields = ['servicio1', 'sentido1', 'nave1', 'viaje1', 'por_onu', 'pol_onu', 'podl_onu', 'direct_ts', 'item_type', 'cnt_type_iso', 'comm_name', 'issuer_name', 'customer_type'];
               $.each(fields, function(k, v){
                   var data = '?field=' + v;
                   var $select = $('#' + v);
                   $.getJSON(url + data, function(json){
                       $.each(json.data, function(key, value){
                          // $select.append("<option value='" + value + "'>" + value + "</option>");
                           console.log(value);
                       });
                   })
               });
*/
           }
        });
    },
    filters: function(){
        var _this = this;
        var data = '';
        $.each(_this._fields, function(k, v){
            if (!!_this._fields[v]){
                $.each(_this._fields[v], function(key, value){
                    data += v + ',' + value + ':';
                });
            }
        });
        data = data.substring(0, data.length-1);
        $.getJSON(_this._url + '?conditions=' + data, function(json){
            $.each(json.demands, function(k, v){
                _this.o_table.fnAddData([v.servicio1, v.sentido1, v.nave1, v.viaje1, v.por_onu, v.pol_onu, v.podl_onu, v.direct_ts, v.item_type, v.cnt_type_iso, v.comm_name, v.issuer_name, v.customer_type, v.cantidad, v.freight_tons_un, v.weight_un, v.teus, v.lost_teus, v.flete_all_in_us_un, v.other_cost, v.peso, v.cost_per_teu, v.accept, v.no_accept]);
            });
        });
    }
};