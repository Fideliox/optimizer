var Status = {
    $leg: $('#sel-leg'),
    $services: $('#sel-services'),
    $search: $('#btn-search'),
    html_widget: 'widget',
    html_ship: 'ship',
    total_ships: 0,
    actual_widgets: 0,
    init: function(){
        var _this = this;
        //_this.set_ports();
        _this.list_legs();
        _this.list_services('');
        _this.bind_search()
    },
    list_legs: function(id){
        var _this = this;
        if (id!=''){
            var url = '/api/v1/results/status/list_leg?service=' + id;
            _this.$leg.empty().append('<option value="">- Selected -</option>');
            $.getJSON(url).done(function(json){
                $.each(json.list, function(key, value){
                    _this.$leg.append('<option value="'+ value +'">' + value + '</option>');
                });
            });
        }
    },
    list_services: function(){
        var _this = this;
        var url = '/api/v1/results/status/list_services';
        $.getJSON(url).done(function(json){
            _this.$services.empty().append('<option value="">- Selected -</option>');
            $.each(json.list, function(key, value){
                _this.$services.append('<option value="'+ value +'">'+ value + '</option>');
            });
            _this.bind_service();
        });
    },
    bind_service: function(){
        var _this = this;
        _this.$services.bind('change', function(){
            var $this = $(this);
            _this.list_legs($this.val());
        });
    },
    bind_search: function(){
        var _this = this;
        _this.$search.bind('click', function(){
            window.$processing_modal.modal('show');
            var a_port = _this.$leg.val().split('-->');
            var url = '/api/v1/results/status/search?service=' + _this.$services.val() + '&port_origin=' + a_port[0] + '&port_destination=' + a_port[1];
            $.getJSON(url).done(function(json){
                var $container = $('#ul-content');
                $container.empty();
                cont = 0;
                _this.total_ships = json.list.length;
                _this.actual_widgets = 0;
                $.each(json.list, function(k, v){
                    cont++;
                    var col = $('<li />', {  }).appendTo($container);
                    var ship = $('<div />', {  }).appendTo(col);
                    _this.template_ship(ship, v.ship, v.travel, v.date, v.resource, col);
                });
                if (json.list.length==0){
                    window.$processing_modal.modal('hide');
                }
            });
        });
    },
    template_widget: function($obj, title, theader, items){
        var _this = this;
        var url = '/templates/data_tables/status/widgets';
        $.Mustache.load(url).done(function (list) {
            $obj.empty().mustache(_this.html_widget, {title: title, theader: theader, items: items});
        }).done(function(data){
                _this.actual_widgets++;
                if ((_this.actual_widgets/2.0) == _this.total_ships){
                    window.$processing_modal.modal('hide');
                    $('body,html').stop(true,true).animate({
                        scrollTop: $('#ul-content').offset().top
                    },1000);
                }
            });
    },
    template_ship: function($obj, ship, travel, date, resource, col){
        var _this = this;
        var url = '/templates/data_tables/status/ships';
        $.Mustache.load(url).done(function (list) {
            $obj.mustache(_this.html_ship, {ship: ship, travel: travel, date: date});
        }).done(function(data){
                var status = $('<div />', { class: 'div-status' }).appendTo(col);
                var container = $('<div />', { class: 'div-container'}).appendTo(col);
                var b = [
                    {
                        name: "FULL"
                    },
                    {
                        name: "EMPTY"
                    }
                ];
                var a = [
                    {
                        name: "CAP"
                    },
                    {
                        name: "ACTUAL"
                    }
                ];
                var url = '/api/v1/results/status/?leg='+resource;
                $.getJSON(url).done(function(json){
                    _this.template_widget(status, 'Status', a , json.items);
                });
                url = '/api/v1/results/status/containers/?leg=' + resource;
                $.getJSON(url).done(function(json){
                    _this.template_widget(container, 'Containers', b , json.items);
                });
            });
    }
};