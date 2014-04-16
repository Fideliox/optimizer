var Process = {
    $barp_routes: $('#barp-routes'),
    $barp_demands: $('#barp-demands'),
    $barp_empty: $('#barp-empty'),
    $barp_solve: $('#barp-solve'),
    $barp_distance: $('#barp-distance'),
    $barp_exporting: $('#barp-exporting'),
    $barp_model: $('#barp-model'),
    $barpw_routes: $('#barpw-routes'),
    $div_routes: $('#div-routes'),
    $btn_routes: $('#btn-routes'),
    $row_routes: $('.row-routes'),
    $label_routes: $('#label-routes'),
    $btn_process: $('.btn-process'),
    $btn_stop: $('#btn-stop'),
    stop: false,
    init: function(){
        var _this = this;
        _this.bind_process();
        _this.$barp_routes.width('0%');
        _this.$barp_demands.width('0%');
        _this.$barp_empty.width('0%');
        _this.$barp_solve.width('0%');
        _this.$barp_distance.width('0%');
        _this.$barp_exporting.width('0%');
        _this.$barp_model.width('0%');
        _this.$barpw_routes.width('0%');
        _this.bind_warning_routes();
        _this.$btn_process.prop('disabled', true);
        _this.bind_stop();
        _this.test_socket();
        _this.task();
    },
    bind_stop: function(){
        var _this = this;
        _this.$btn_stop.bind('click', function(e){
            bootbox.confirm("Want to stop all process?", function(result) {
                if(result){
                    var url = '/api/v1/process/socket/execute?id=9'
                    $.getJSON(url).complete(function(response){
                        if (response.status==200){
                            _this.stop = true;
                        }
                    });
                }
            });
        });
    },
    bind_warning_routes: function(){
        var _this = this;
        _this.$btn_routes.bind('click', function(){
            var url = '/api/v1/process/status/routes';
            $.getJSON(url).complete(function(response){
                if (response.status==200){
                    _this.$row_routes.show();
                }
            });
        });
    },
    test_socket: function(){
        var _this = this;
        var $div = $('#div-status');
        var url = "/api/v1/process/socket/vb"
        $.getJSON(url).done(function(json){
            if (json.status){
                $div.html('<div>Socket server: <span class="text-success">ON LINE</span></div>');
                _this.$btn_process.prop('disabled', false);
            }else{
                $div.html('<div>Socket server: <span class="text-danger">OFF LINE</span></div>');
                _this.$btn_process.prop('disabled', true);
            }
        });
    },
    task: function(){
        var _this = this;
        var url = '/api/v1/process/status';
        $.getJSON(url).complete(function(response){
            if (response.status==200){
                _this.$barp_routes.width(response.responseJSON.rutas_factibles[0].porcentaje + '%');
                _this.$barp_demands.width(response.responseJSON.loader_master_shipments + '%');
                _this.$barp_empty.width(response.responseJSON.loader_empty_containers + '%');
                _this.$barp_solve.width(response.responseJSON.solve + '%');
                _this.$barp_distance.width(response.responseJSON.set_distance + '%');
                _this.$barp_exporting.width(response.responseJSON.export + '%');
                _this.$barp_model.width(response.responseJSON.init_model + '%');
                _this.$label_routes.html(response.responseJSON.rutas_factibles[0].actual + ' / ' + response.responseJSON.rutas_factibles[0].limite );
                var sw = false;
                if(response.responseJSON.rutas_factibles[0].porcentaje < 100 ||
                    response.responseJSON.loader_master_shipments < 100 ||
                    response.responseJSON.loader_empty_containers < 100 ||
                    response.responseJSON.solve < 100 ||
                    response.responseJSON.set_distance < 100 ||
                    response.responseJSON.export < 100
                    ){
                    sw = true;
                }

                if (response.responseJSON.rutas_factibles[0].porcentaje == 100){
                    _this.$barp_routes.parent().removeClass('active');
                }else{
                    if(!_this.$barp_routes.parent().hasClass('active')){
                        _this.$barp_routes.parent().addClass('active');
                    }
                }
                if (response.responseJSON.loader_master_shipments != 0){
                    if(_this.$barp_routes.parent().hasClass('active')){
                        _this.$barp_routes.parent().removeClass('active');
                        var result = 100 - response.responseJSON.rutas_factibles[0].porcentaje;
                        _this.$barpw_routes.width(result + '%');
                        _this.$div_routes.show();
                    }
                }
                if (response.responseJSON.loader_master_shipments == 100){
                    _this.$barp_demands.parent().removeClass('active');
                }else{
                    if (!_this.$barp_demands.parent().hasClass('active')){
                        _this.$barp_demands.parent().addClass('active');
                    }
                }
                if (response.responseJSON.loader_empty_containers == 100){
                    _this.$barp_empty.parent().removeClass('active');
                }else{
                    if (!_this.$barp_empty.parent().hasClass('active')){
                        _this.$barp_empty.parent().addClass('active');
                    }
                }
                if (response.responseJSON.solve == 100){
                    _this.$barp_solve.parent().removeClass('active');
                }else{
                    if (!_this.$barp_solve.parent().hasClass('active')){
                        _this.$barp_solve.parent().addClass('active');
                    }
                }
                if (response.responseJSON.export == 100){
                    _this.$barp_exporting.parent().removeClass('active');
                }else{
                    if (!_this.$barp_exporting.parent().hasClass('active')){
                        _this.$barp_exporting.parent().addClass('active');
                    }
                }
                if (response.responseJSON.set_distance == 100){
                    _this.$barp_distance.parent().removeClass('active');
                }else{
                    if (!_this.$barp_distance.parent().hasClass('active')){
                        _this.$barp_distance.parent().addClass('active');
                    }
                }
                if (response.responseJSON.init_model == 100){
                    _this.$barp_model.parent().removeClass('active');
                }else{
                    if (!_this.$barp_model.parent().hasClass('active')){
                        _this.$barp_model.parent().addClass('active');
                    }
                }
                if (sw && !_this.stop){
                    setTimeout(function(){ _this.task(); }, 2000);
                    _this.$btn_process.prop('disabled', true);
                }else{
                    _this.$btn_process.prop('disabled', false);
                    _this.$barp_routes.width('100%');
                    _this.$barp_demands.width('100%');
                    _this.$barp_empty.width('100%');
                    _this.$barp_solve.width('100%');
                    _this.$barp_distance.width('100%');
                    _this.$barp_exporting.width('100%');
                    _this.$barp_model.width('100%');

                    _this.$barp_routes.parent().removeClass('active');
                    _this.$barp_demands.parent().removeClass('active');
                    _this.$barp_empty.parent().removeClass('active');
                    _this.$barp_solve.parent().removeClass('active');
                    _this.$barp_distance.parent().removeClass('active');
                    _this.$barp_exporting.parent().removeClass('active');
                    _this.$barp_model.parent().removeClass('active');
                }
            }
        });
    },
    bind_process: function(){
        var _this = this;
        var $btn_process = $('.btn-process');
        $btn_process.bind('click', function(){
            var $this = $(this);
            var url = '/api/v1/process/socket/execute?id=' + $this.data('object');
            _this.$barpw_routes.width('0%');
            bootbox.confirm("Want to run this process?", function(result) {
                if(result){
                    $.get(url).complete(function(response){
                        if (response.status==200){
                            setTimeout(function(){ _this.task(); }, 2000);
                        }
                    });
                }
            });
        });
    },
};