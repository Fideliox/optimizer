//= require twitter/bootstrap/tab
var Setting = {
    _$pserver: $('#pserver'),
    _$puser: $('#puser'),
    _$ppass: $('#ppass'),
    _$pdbname: $('#pdbname'),
    _$pport: $('#pport'),
    _$rserver: $('#rserver'),
    _$ruser: $('#ruser'),
    _$rpass: $('#rpass'),
    _$rdbname: $('#rdbname'),
    _$rport: $('#rport'),
    _$psave: $('#psave'),
    _$sserver: $('#sserver'),
    _$sport: $('#sport'),
    _$ssave: $('#ssave'),
    _$rsave: $('#rsave'),
    _$tab_setting: $('#tab_setting'),
    _$div_socket: $('#div-socket'),
    _$div_server: $('#div-server'),
    _$div_rds: $('#div-rds'),
    init: function(){
        var _this = this;
        _this._bind_psave();
        _this._bind_ssave();
        _this._bind_rsave();
        _this._bind_tabs();
        _this._test_socket(_this._$sserver.val(), _this._$div_socket);
        _this._test_socket(_this._$pserver.val(), _this._$div_server);
        _this._test_socket(_this._$rserver.val(), _this._$div_rds);
    },
    _test_socket: function(host, $div){
        var _this = this;
        var url = "/api/v1/process/socket/ping?host=" + host;
        $.getJSON(url).done(function(json){
            if (json.status){
                $div.html('<div class="text-success">ON LINE</div>');
            }else{
                $div.html('<div class="text-danger">OFF LINE</div>');
            }
        });
    },
    _bind_tabs: function(){
        var _this = this;
        _this._$tab_setting.tab('show');
        _this._$tab_setting.first().tab('show');
    },
    _bind_rsave: function(){
        var _this = this;
        _this._$rsave.bind('click', function(){
            var url = '/api/v1/settings/';
            var data = {
                rds_ip: _this._$rserver.val(),
                rds_user: _this._$ruser.val(),
                rds_password: _this._$rpass.val(),
                rds_dbname: _this._$rdbname.val(),
                rds_port: _this._$rport.val()
            };
            $('#processing-modal').modal();
            $.post(url, data).done(function(json){
                if(json.result == 'OK'){
                    //oK
                }
                $('#processing-modal').modal('hide');
            });
        });
    },
    _bind_psave: function(){
        var _this = this;
        _this._$psave.bind('click', function(){
            var url = '/api/v1/settings/';
            var data = {
                postgresql_ip: _this._$pserver.val(),
                postgresql_user: _this._$puser.val(),
                postgresql_password: _this._$ppass.val(),
                postgresql_dbname: _this._$pdbname.val(),
                postgresql_port: _this._$pport.val()
            };
            $('#processing-modal').modal();
            $.post(url, data).done(function(json){
                if(json.result == 'OK'){
                    //oK
                }
                $('#processing-modal').modal('hide');
            });
        });
    },
    _bind_ssave: function(){
        var _this = this;
        var url = '/api/v1/settings/';
        _this._$ssave.bind('click', function(){
            var data = { socket_ip: _this._$sserver.val(), socket_port: _this._$sport.val() };
            $('#processing-modal').modal();
            $.post(url, data).done(function(json){
                if(json.result == 'OK'){
                    //OK
                }
                $('#processing-modal').modal('hide');
            });
        });
    }
};