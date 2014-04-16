//= require chart/raphael-min
//= require chart/morris.min
var Stocks = {
    _$container_type: $('#container-type'),
    _$contries: $('#countries'),
    _$ports: $('#ports'),
    _$morris: $('#morris'),
    _$btn_search: $('#btn-search'),
    _checkbox_containers: [],
    init: function(){
        var _this = this;
        _this._list_containers();
        _this._bind_countries();
        _this._bind_btn_search();
    },
    _morris_bar: function(div, data){
        var _this = this;
        if ($('#bar-' + div).length==0){
            $('<div />', { id: 'bar-'+div }).appendTo(_this._$morris);
        }else{
            $('#bar-' + div).empty();
        }
        console.log(data);
        var values = []
        for(var i=0; i<data.length; i++){
            values.push({y: data[i].date, a: data[i].stock_ini})
        }
        Morris.Bar({
            element: 'bar-'+div,
            data: values,
            xkey: 'y',
            ykeys: ['a'],
            labels: ['Stock ' + div]
        });
    },
    _list_containers: function(){
        var _this = this;
        window.$processing_modal.modal('show');
        var url = '/api/v1/results/stocks/list_containers';
        _this._$container_type.empty();
        $.getJSON(url).done(function(json){
            $.each(json.list, function(key, value){
                _this._add_checkbox(value);
                _this._bind_checkbox(value);
            });
            _this._list_countries();
        });
    },
    _add_checkbox: function(name) {
        var _this = this;
        $('<input />', { type: 'checkbox', id: name, value: name }).appendTo(_this._$container_type);
        $('<label />', { 'for': name, text: name, class: 'container-name' }).appendTo(_this._$container_type);
        $('<br />').appendTo(_this._$container_type);
    },
    _bind_checkbox: function(name){
        var _this = this;
        var $checkbox = $('#' + name);
        $checkbox.bind('click', function(){
            var $this = $(this);
            $('#bar-' + name).remove();
            if ($this.is(':checked')) {
                _this._checkbox_containers.push($this.val());
            }else{
                _this._checkbox_containers = $.grep(_this._checkbox_containers, function(value) {
                    return value != $this.val();
                });
            }
        });
    },
    _list_countries: function(){
        var _this = this;
        var url = '/api/v1/results/stocks/list_countries';
        _this._$contries.empty().append('<option value="">- All -</option>');
        $.getJSON(url).done(function(json){
            $.each(json.countries, function(key, value){
                _this._$contries.append('<option value="'+ value.id +'">'+ value.code + ' - ' + value.name +'</option>');
            });
            _this._list_ports('');
        });
    },
    _list_ports: function(code){
        var _this = this;
        var url = '/api/v1/results/stocks/list_ports?country_id=' + code;
        _this._$ports.empty().append('<option value="">- All -</option>');
        $.getJSON(url).done(function(json){
            $.each(json.ports, function(key, value){
                _this._$ports.append('<option value="'+ value.country + value.code +'">'+ value.code + ' - ' + value.name + '</option>');
            });
            window.$processing_modal.modal('hide');
        });
    },
    _bind_countries: function(){
        var _this = this;
        _this._$contries.bind('change', function(){
            window.$processing_modal.modal('hide');
            _this._list_ports($(this).val());
        });
    },
    _bind_btn_search: function(){
        var _this = this;
        _this._$btn_search.bind('click', function(){
            window.$processing_modal.modal('show');
            var url = '/api/v1/results/stocks/search';
            var data = '?country=' + _this._$contries.val() + '&port=' + _this._$ports.val() +  '&containers=' +  _this._checkbox_containers.join(',')
            $.getJSON(url + data).done(function(json){
                if (json.containers[0].length > 0){
                    $.each(json.containers, function(key, value){
                        _this._morris_bar(value[0].container_type, value);
                    });
                }
                window.$processing_modal.modal('hide');
            });
        });
    }
};