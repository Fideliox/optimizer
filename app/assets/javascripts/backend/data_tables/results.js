var Results = {
    _fields: ['nave', 'viaje', 'puerto_origen', 'puerto_destino'],
    _html_data_grid_results: 'data-grid-results',
    _html_data_grid_results_details: 'data-grid-results-details',
    _html_data_grid_results_details_dda: 'data-grid-results-details-dda',
    _$restuls: $('#results'),
    init: function(){
        var _this = this;
        _this._get_all_filters();
        _this._bind_ship();
        _this._bind_location();
        _this._bind_btn_search();
    },
    _templates_data_grids_results: function(list){
        var _this = this;
        var url = '/templates/data_tables/results/data_grid_results';
        $.Mustache.load(url).done(function () {
            _this._$restuls.empty().mustache(_this._html_data_grid_results, {list: list});
        }).done(function(data){
                window.$processing_modal.modal('hide');
                $('body,html').stop(true,true).animate({
                    scrollTop: $('.table-responsive').offset().top
                },1000);
                _this._bind_more_results();
        });
    },
    _bind_more_results: function(){
        var _this = this;
        var $more_results  = $('.more-results');
        $more_results.unbind('click');
        $more_results.bind('click', function(){
            var $this = $(this);
            var $result_detail = $('#' + $this.data('object').replace(/:/g, '').replace(/ /g, '').replace(/\(/g, '').replace(/\)/g, '').replace(/\//g, ''));
            if($this.text()=='+'){
                $this.text('-');
                var url = '/api/v1/results/demands/detail?resource=' + $this.data('object');
                window.$processing_modal.modal('show');
                $.getJSON(url).done(function(json){
                    var url = '/templates/data_tables/results/data_grid_results_details';
                    $.Mustache.load(url).done(function () {
                        var list = [];
                        $.each(json.list, function(key, value){
                            list.push({
                                "type": value.type,
                                "cost_per_teu_leg": Utils.number_format(value.cost_per_teu_leg, 0, ',', '.'),
                                "total_cost_per_teu_leg": Utils.number_format(value.total_cost_per_teu_leg, 0, ',', '.'),
                                "max_units": Utils.number_format(value.max_units, 0, ',', '.'),
                                "sol_units_teu": Utils.number_format(value.sol_units_teu, 0, ',', '.'),
                                "rate_per_teu": Utils.number_format(value.rate_per_teu, 0, ',', '.'),
                                "opp_value_per_teu": Utils.number_format(value.opp_value_per_teu, 0, ',', '.'),
                                "object": value.dda.replace(/:/g, '').replace(/ /g, '').replace(/\(/g, '').replace(/\)/g, '').replace(/\//g, ''),
                                "dda": value.dda
                            });
                        });
                        $result_detail.empty().mustache(_this._html_data_grid_results_details, {list: list});
                    }).done(function(data){
                            $result_detail.slideDown('slow');
                            window.$processing_modal.modal('hide');
                            _this._bind_more_results_detail();
                        });
                });
            }else{
                window.$processing_modal.modal('show');
                $this.text('+');
                $result_detail.slideUp('slow', function(){
                    $result_detail.empty();
                    window.$processing_modal.modal('hide');
                });
            }
        });
    },
    _bind_more_results_detail: function(){
        var _this = this;
        var $more_dda = $('.more-dda');
        $more_dda.bind('click', function(){
            window.$processing_modal.modal('show');
            var $this = $(this);
            var $object = $('#' + $this.data('object').replace(/:/g, '').replace(/ /g, '').replace(/\(/g, '').replace(/\)/g, '').replace(/\//g, ''));
            console.log($object);
            if($this.text()=='+'){
                $this.text('-');
                var url = '/api/v1/results/demands/dda?dda=' + $this.data('object');
                $.getJSON(url).done(function(json){
                    var url = '/templates/data_tables/results/data_grid_results_details_dda';
                    $.Mustache.load(url).done(function () {
                        var list = [];
                        $.each(json.list, function(key, value){
                            list.push({
                                "cost_per_teu_leg": Utils.number_format(value.cost_per_teu_leg, 0, ',', '.'),
                                "opp_value_per_teu": Utils.number_format(value.opp_value_per_teu, 0, ',', '.')
                            });
                        });
                        $object.empty().mustache(_this._html_data_grid_results_details_dda, {list: list});
                    }).done(function(data){
                        $object.slideDown('slow');
                        window.$processing_modal.modal('hide');
                    });
                });
                $object.slideDown('slow');
            }else{
                $this.text('+');
                $object.slideUp('slow', function(){
                    $object.empty();
                    window.$processing_modal.modal('hide');
                });
            }
        });
    },
    _get_all_filters: function(){
        var _this = this;
        var url = '/api/v1/results/demands/unq_cap';
        $.each(_this._fields, function(k, v){
            var data = '?field=' + v;
            var $select = $('#' + v);
            $.getJSON(url + data, function(json){
                $select.append("<option value=''>- All -</option>");
                $.each(json.list, function(key, value){
                    $select.append("<option value='" + value + "'>" + value + "</option>");
                });
            });
        });
    },
    _bind_btn_search: function(){
        var _this = this;
        var $btn_searh = $("#btn-search");
        $btn_searh.bind('click', function(){
            window.$processing_modal.modal('show');
            var url = '/api/v1/results/demands/search';
            var data = '?';
            $.each(_this._fields, function(k, v){
                var $obj = $('#' + v);
                data += v + '=' + $obj.val() + '&';
            });
            data = data.substring(0, data.length-1);
            $.getJSON(url + data).done(function(json){
                var list = [];
                $.each(json.list, function(key, r){
                    var class_teu = '', class_plugs = '', class_weight = '';
                    if((r.max_teu - r.used_teu)==0)
                        class_teu = 'danger';
                    if((r.max_plugs_teu - r.used_plugs)==0)
                        class_plugs = 'danger';
                    if((r.max_weight - r.used_weight) == 0)
                        class_weight = 'danger';
                    list.push(
                        {
                            "object": r.resource.replace(/:/g, '').replace(/ /g, '').replace(/\(/g, '').replace(/\)/g, '').replace(/\//g, ''),
                            "resource": r.resource,
                            "ship": r.nave,
                            "travel": r.viaje,
                            "location": r.puerto_origen,
                            "destination": r.puerto_destino,
                            "max_teu": Utils.number_format(r.max_teu, 0, ',', '.'),
                            "used_teu": Utils.number_format(r.used_teu, 0, ',', '.'),
                            "empty_teu": Utils.number_format(r.empty_teu, 0, ',', '.'),
                            "class_teu": class_teu,
                            "max_plugs_teu": Utils.number_format(r.max_plugs_teu/2, 0, ',', '.'),
                            "used_plugs": Utils.number_format(r.used_plugs/2, 0, ',', '.'),
                            "class_plugs": class_plugs,
                            "max_weight": Utils.number_format(r.max_weight, 0, ',', '.'),
                            "used_weight": Utils.number_format(r.used_weight, 0, ',', '.'),
                            "class_weight": class_weight
                        }
                    );
                });
                _this._templates_data_grids_results(list);
            });
        });
    },
    _bind_ship: function(){
        var _this = this;
        var $select = $('#nave');
        $select.bind('change', function(){
            var url = '/api/v1/results/demands/filter_travel';
            $.getJSON(url + '?ship=' + $select.val(), function(json){
                var $select2 = $('#viaje');
                $select2.empty().append("<option value=''>- All -</option>");
                $.each(json.list, function(key, value){
                    $select2.append("<option value='" + value + "'>" + value + "</option>");
                });
            });

            url = '/api/v1/results/demands/filter_por_onu';
            $.getJSON(url + '?ship=' + $select.val(), function(json){
                var $select2 = $('#puerto_origen');
                $select2.empty().append("<option value=''>- All -</option>");
                $.each(json.list, function(key, value){
                    $select2.append("<option value='" + value + "'>" + value + "</option>");
                });
            });
            /* Filtro por contenedor
            url = '/api/v1/results/demands/filter_cnt_type_iso';
            $.getJSON(url + '?ship=' + $select.val(), function(json){
                var $select2 = $('#cnt_type_iso');
                $select2.empty().append("<option value=''>- All -</option>");
                $.each(json.list, function(key, value){
                    $select2.append("<option value='" + value + "'>" + value + "</option>");
                });
            });
            */
        });
    },
    _bind_location: function(){
        var _this = this;
        var $select = $('#puerto_origen');
        $select.bind('change', function(){
            var url = '/api/v1/results/demands/filter_pod_onu';
            $.getJSON(url + '?location=' + $select.val() + '&ship=' + $('#nave').val() + '&travel=' + $('#viaje').val() , function(json){
                var $select2 = $('#puerto_destino');
                $select2.empty().append("<option value=''>- All -</option>");
                $.each(json.list, function(key, value){
                    $select2.append("<option value='" + value + "'>" + value + "</option>");
                });
            });
        });
    },
    /*
    *
    * NOT FOUND
    *
    * */
    _bind_new_filters: function(){
        var _this = this;
        var $selectpicker = $('.selectpicker');
        $selectpicker.bind('change', function(){
            var url = '/api/v1/results/demands/filter';
            var data = '"filters": { ';
            $.each(_this._fields, function(k, v){
                var $obj = $('#' + v);
                data += '"' + v + '": "' + $obj.val() + '",';
            });
            data = "{ " + data.substring(0, data.length-1);
            $.each(_this._fields, function(k, v){
                var data_aux = data + ', "field": "' + v + '"} }';
                var $select = $('#' + v);
                $select.empty();
                $.post(url, JSON.parse(data_aux), function(json) {
                    $select.append("<option value=''>- All -</option>");
                    $.each(json.list, function(key, value){
                        $select.append("<option value='" + value + "'>" + value + "</option>");
                    });
                }, 'json');
            });
        });
    }
};