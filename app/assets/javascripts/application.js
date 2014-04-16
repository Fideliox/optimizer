//= require jquery
//= require jquery_ujs
//= require bootbox.min
//= require twitter/bootstrap/tooltip
//= require twitter/bootstrap/popover
//= require admin/gritter
//= require admin/jquery.nicescroll
//= require admin/jquery.scrollTo.min
//= require admin/jquery.gritter
//= require admin/jquery.dcjqaccordion.2.7
//= require admin/common-script
//= require twitter/bootstrap/dropdown
//= require twitter/bootstrap/modal

//= require mustache
//= require jquery.mustache



window.$processing_modal = $('#processing-modal');

var Task = {
    _$processing_modal: $('#processing-modal'),
    _$bar_costs: $('#bar-costs'),
    _$text_costs: $('#text-costs'),
    _$bar_stocks: $('#bar-stocks'),
    _$text_stocks: $('#text-stocks'),
    _$bar_itineraries: $('#bar-itineraries'),
    _$text_itineraries: $('#text-itineraries'),
    _$bar_demands: $('#bar-demands'),
    _$text_demands: $('#text-demands'),
    _$bar_capabilities: $('#bar-capabilities'),
    _$text_capabilities: $('#text-capabilities'),
    _$text_task: $('#text-task'),
    _$text_stocks_filename: $('#text-stocks-filename'),
    _$text_costs_filename: $('#text-costs-filename'),
    _$text_itineraries_filename: $('#text-itineraries-filename'),
    _$text_demands_filename: $('#text-demands-filename'),
    _$text_capabilities_filename: $('#text-capabilities-filename'),
    init: function(){
        var _this = this;
        _this._$text_task.text('0');
        _this._$bar_itineraries.addClass('progress-bar-success');
        _this._$bar_demands.addClass('progress-bar-success');
        _this._$bar_capabilities.addClass('progress-bar-success');
        _this._$bar_costs.addClass('progress-bar-success');
        _this._$bar_stocks.addClass('progress-bar-success');
        _this._$bar_itineraries.parent().addClass('active');
        _this._$bar_demands.parent().addClass('active');
        _this._$bar_capabilities.parent().addClass('active');
        _this._$bar_costs.parent().addClass('active');
        _this._$bar_stocks.parent().addClass('active');
        _this._check_iz_files()
    },
    _check_iz_files: function(){
        var _this = this;
        var url = '/api/v1/process/iz_files/status?type_id=1,2,3,4,5';
        $.get(url).done(function(json){
            var filename = 'ERROR';
            var i = json.status.itineraries.percentage;
            var d = json.status.demands.percentage;
            var c = json.status.capabilities.percentage;
            var co = json.status.costs.percentage;
            var s = json.status.stocks.percentage;
            var ifilename = json.status.itineraries.error ? filename:json.status.itineraries.filename;
            var dfilename = json.status.demands.error ? filename:json.status.demands.filename;
            var cfilename = json.status.capabilities.error ? filename:json.status.capabilities.filename;
            var cofilename = json.status.costs.error ? filename:json.status.costs.filename;
            var sfilename = json.status.stocks.error ? filename:json.status.stocks.filename;
            var sw = false;
            var cont = 5;
            _this._$text_itineraries.text(i + ' %');
            _this._$text_demands.text(d + ' %');
            _this._$text_capabilities.text(c + ' %');
            _this._$text_costs.text(co + ' %');
            _this._$text_stocks.text(s + ' %');
            _this._$bar_itineraries.width(i + '%');
            _this._$bar_demands.width(d + '%');
            _this._$bar_capabilities.width(c + '%');
            _this._$bar_costs.width(co + '%');
            _this._$bar_stocks.width(s + '%');
            _this._$text_itineraries_filename.text('Itinerary: ' + ifilename);
            _this._$text_demands_filename.text('Demand: ' + dfilename);
            _this._$text_capabilities_filename.text('Capacity: ' + cfilename);
            _this._$text_costs_filename.text('Costs: ' + cofilename);
            _this._$text_stocks_filename.text('Stocks: ' + sfilename);
            if(parseInt(i) < 100 || parseInt(d) < 100 || parseInt(c) < 100 || parseInt(co) < 100 || parseInt(s) < 100)
                sw = true;
            if (parseInt(i) == 100) {
                cont--;
                _this._$bar_itineraries.parent().removeClass('active');

            }
            if (parseInt(d) == 100){
                cont--;

                _this._$bar_demands.parent().removeClass('active');
            }
            if (parseInt(c) == 100){
                cont--;
                _this._$bar_capabilities.parent().removeClass('active');
            }
            if (parseInt(co) == 100){
                cont--;
                _this._$bar_costs.parent().removeClass('active');
            }
            if (parseInt(s) == 100){
                cont--;
                _this._$bar_stocks.parent().removeClass('active');
            }
            _this._$text_task.text(cont);
            if (sw){
                setTimeout(function(){ _this._check_iz_files(); }, 2000);
            }else{
                _this._$processing_modal.modal('hide');
            }
        });
    }
};
var Utils = {
    number_format: function (numero, decimales, separador_decimal, separador_miles){
        numero=parseFloat(numero);
        if(isNaN(numero)){
            return "";
        }
        if(decimales!==undefined){
            // Redondeamos
            numero=numero.toFixed(decimales);
        }
        numero=numero.toString().replace(".", separador_decimal!==undefined ? separador_decimal : ",");
        if(separador_miles){
            // Añadimos los separadores de miles
            var miles=new RegExp("(-?[0-9]+)([0-9]{3})");
            while(miles.test(numero)) {
                numero=numero.replace(miles, "$1" + separador_miles + "$2");
            }
        }
        return numero;
    }
};
//Task.init();