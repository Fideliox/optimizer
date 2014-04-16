//= require jquery.uploadfile.min

var Uploaders = {
    _$btn_process: $('.btn-process'),
    _$socket: $('#div-socket'),
    _$processing_modal: $('#processing-modal'),
    _itineraries: [],
    _demands: [],
    _capacities: [],
    _costs: [],
    _stocks: [],
    $_itineraries: $('#div-itineraries'),
    $_demands: $('#div-demands'),
    $_capacities: $('#div-capacities'),
    _$cost: $('#div-costs'),
    _$stocks: $('#div-stocks'),
    $_delete: null,
    $_csv_to_db: null,
    _html_data_grid: 'data-grid-files',
    _html_data_socket: 'data-socket',
    processing: false,
    $console_btn: $('#btn-console'),
    $console_body: $('#console-body'),
    $btn_check: $('.btn-check'),
    init: function(){
        var _this = this;
        var $div = $('#div-status');
        $('.csv_to_db').prop('disabled', true);
        $("#uploaders").addClass('active');
        $(".icon-chevron-down").click();
        _this._data_grids();
        _this._templates_socket();
        $div.html('<div>Server loader: <span class="text-danger">OFF LINE</span></div>');
        setTimeout(function(){
            Task.init();
        }, 3000);
        _this.bind_console();
    },
    bind_console: function(){
        var _this = this;
        _this.$console_btn.bind('click', function(){
            var url = '/api/v1/process/iz_files/read_log';
            $.get(url).done(function(html){
                _this.$console_body.html(html);
            });
        });
    },
    _test_socket: function(){
        var $div = $('#div-status');
        var url = "/api/v1/process/socket/eo"
        $.getJSON(url).done(function(json){
            if (json.status){
                $div.html('<div>Server loader: <span class="text-success">ON LINE</span></div>');
                $('.csv_to_db').prop('disabled', false);
            }else{
                $div.html('<div>Server loader: <span class="text-danger">OFF LINE</span></div>');
                $('.csv_to_db').prop('disabled', true);
            }
        });
    },
    _data_grids: function(){
        var _this = this;
        var url = '/api/v1/main/iz_files/list?type_id=1,2,3,4,5';
        _this._itineraries = [];
        _this._demands = [];
        _this._capacities = [];
        _this._costs = [];
        _this._stocks = [];
        $.getJSON(url, function(){
        }).done(function(json){
            $.each(json.list, function(key, value){
                switch (value.iz_file_type_id){
                    case 1:
                        _this._itineraries.push({
                                id: value.id,
                                name: value.name.split('/').pop(),
                                download: '/backend/loader/uploaders/file.csv?id=' + value.id,
                                iz_file_type_id: value.iz_file_type_id
                            });
                        break;
                    case 2:
                        _this._demands.push({
                            id: value.id,
                            name: value.name.split('/').pop(),
                            download: '/backend/loader/uploaders/file.csv?id=' + value.id,
                            iz_file_type_id: value.iz_file_type_id
                        });
                        break;
                    case 3:
                        _this._capacities.push({
                            id: value.id,
                            name: value.name.split('/').pop(),
                            download: '/backend/loader/uploaders/file.csv?id=' + value.id,
                            iz_file_type_id: value.iz_file_type_id
                        });
                        break;
                    case 4:
                        _this._costs.push({
                            id: value.id,
                            name: value.name.split('/').pop(),
                            download: '/backend/loader/uploaders/file.csv?id=' + value.id,
                            iz_file_type_id: value.iz_file_type_id
                        });
                        break;
                    case 5:
                        _this._stocks.push({
                            id: value.id,
                            name: value.name.split('/').pop(),
                            download: '/backend/loader/uploaders/file.csv?id=' + value.id,
                            iz_file_type_id: value.iz_file_type_id
                        });
                        break;
                }
            });
            _this._templates_data_grids();
        });
    },
    _templates_data_grids: function(){
        var _this = this;
        var url = '/templates/loader/uploaders/data_grid_files';
        $.Mustache.load(url).done(function () {
            _this.$_itineraries.empty().mustache(_this._html_data_grid, {list: _this._itineraries, tite: 'Itinerary Files', upload: 'uploader_i' });
        }).done(function(data){
            _this._bind_uploaders('uploader_i', 1);
            $.Mustache.load(url).done(function () {
                _this.$_demands.empty().mustache(_this._html_data_grid, {list: _this._demands, tite: 'Forecast/Demand Files', upload: 'uploader_d' });
            }).done(function(){
                _this._bind_uploaders('uploader_d', 2);
                $.Mustache.load(url).done(function () {
                    _this.$_capacities.empty().mustache(_this._html_data_grid, {list: _this._capacities, tite: 'Vessel Capacity Files', upload: 'uploader_c' });
                }).done(function(data){
                    _this._bind_uploaders('uploader_c', 3);
                    $.Mustache.load(url).done(function () {
                        _this._$cost.empty().mustache(_this._html_data_grid, {list: _this._costs, tite: 'Port Costs Files', upload: 'uploader_co' });
                    }).done(function(){
                        _this._bind_uploaders('uploader_co', 4);
                            $.Mustache.load(url).done(function () {
                                _this._$stocks.empty().mustache(_this._html_data_grid, {list: _this._stocks, tite: 'Initial Container Stocks Files', upload: 'uploader_s' });
                            }).done(function(){
                                _this._bind_uploaders('uploader_s', 5);
                                _this._bind_delete();
                                _this._bind_csv_to_db();
                                _this._test_socket();
                                _this.bind_check();
                            });
                    });
                });
            });
        });
    },
    _templates_socket: function(){
        var _this = this;
        var url = '/templates/loader/uploaders/data_socket';
        $.Mustache.load(url).done(function () {
            _this._$socket.empty().mustache(_this._html_data_socket, { });
        }).done(function(data){
                _this._bind_process();
        });
    },
    _bind_process: function(){
        /*
        var _this = this;
        _this._$btn_process = $('.btn-process');
        _this._$btn_process.bind('click', function(){
            var $this = $(this);
            var url = '/api/v1/process/socket/execute?id=' + $this.data('object');
            bootbox.confirm("Want to run this process?", function(result) {
                if(result){
                    $.get(url).done(function(data){
                        if (data.result == 'OK'){
                            _this.processing = true;
                        }
                    });
                }
            });
        });
        */
    },
    _bind_uploaders: function(fileName, iz_file_type_id){
        var _this = this;
        var settings = {
            url: "/api/v1/main/iz_files/upload_csv",
            method: "POST",
            allowedTypes: "txt,tsv",
            fileName: fileName,
            multiple: true,
            onSuccess:function(files,data,xhr)
            {
                if (data.status=='OK'){
                    var _url = '/api/v1/main/iz_files/';
                    var _data = { name: files[0], iz_file_type_id: iz_file_type_id };
                    $.post(_url, _data).done(function(data){
                        if (data.status=='OK'){
                            _this._data_grids();
                        }
                    });
                }
                $("#status").html("<font color='green'>Upload is success</font>");

            },
            onError: function(files,status,errMsg)
            {
                $("#status").html("<font color='red'>Upload is Failed</font>");
            }
        };
        $("#" + fileName).uploadFile(settings);
    },
    _bind_delete: function(){
        var _this = this;
        _this.$_delete = $('.btn-delete');
        _this.$_delete.unbind();
        _this.$_delete.bind('click', function(){
            var $this = $(this);
            var id = $this.data('object');
            var url = '/api/v1/main/iz_files/' + id;
            bootbox.confirm("Want to delete this record?", function(result) {
                if(result){
                    $.ajax({
                        url: url,
                        type: 'DELETE',
                        success: function(data) {
                            if (data.status=='OK'){
                                $this.parent().parent().remove();
                            }
                        }
                    });
                }
            });

        });
    },
    _bind_csv_to_db: function(){
        var _this = this;
        _this.$_csv_to_db = $('.csv_to_db');
        _this.$_csv_to_db.unbind();
        _this.$_csv_to_db.bind('click', function(){
            var $this = $(this);
            var id = $this.data('object');
            var url = '/api/v1/process/iz_files/reload_csv?id=' + id;
            bootbox.confirm("Want to run this process?", function(result) {
                if(result){
                    _this._$processing_modal.modal('show');
                    $.getJSON(url).done(function(json){
                        if(json.status == 'OK'){
                            setTimeout(function(){
                                Task.init();
                            }, 3000);
                        }
                    });
                }
            });
        });
    },
    bind_check: function(){
        var _this = this;
        _this.$btn_check = $('.btn-check');
        _this.$btn_check.unbind();
        _this.$btn_check.bind('click', function(){
            var $this = $(this);
            bootbox.confirm('Do you want to analyze the file?', function(result) {
                if(result){
                    var url = '/api/v1/process/iz_files/read_log?file=' + $this.data('file') + '&id=' + $this.data('object');
                    _this._$processing_modal.modal('show');
                    $.get(url).done(function(text){
                        bootbox.alert(text);
                        _this._$processing_modal.modal('hide');
                    });
                }
            });
        });
    }
};