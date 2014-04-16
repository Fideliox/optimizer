var Week = {
    $week_leg: $('#week_leg'),
    $vessel: $('#vessel'),
    $services: $('#services'),
    $voyage: $('#voyage'),
    $origin: $('#origin'),
    $destination: $('#destination'),
    $month: $('#month'),
    $btn_search: $('#btn-search'),
    init: function(){
        var _this = this;
        _this.list_week_leg();
        _this.list_vessel();
        _this.list_services();
        _this.list_voyage('');
        _this.list_origin('');
        _this.list_destination('');
        _this.list_month();
        _this.bind_search();
    },
    list_week_leg: function(){
        var _this = this;
        var url = '/api/v1/results/week/list_week_leg';
        $.get(url).done(function(json){
            var list = json.list;
            _this.$week_leg.empty().append("<option>- Selected -</option>");
            for(i=0; i < list.length; i++){
                _this.$week_leg.append("<option value='"+ list[i] + "'>" + list[i] + "</option>")
            }
        });
    },
    list_vessel: function(){
        var _this = this;
        var url = '/api/v1/results/week/list_vessel';
        $.get(url).done(function(json){
            var list = json.list;
            _this.$vessel.empty().append("<option>- Selected -</option>");
            for(i=0; i < list.length; i++){
                _this.$vessel.append("<option value='"+ list[i] + "'>" + list[i] + "</option>")
            }
            _this.bind_vessel();
        });
    },
    list_services: function(){
        var _this = this;
        var url = '/api/v1/results/week/list_services';
        $.get(url).done(function(json){
            var list = json.list;
            _this.$services.empty().append("<option>- Selected -</option>");
            for(i=0; i < list.length; i++){
                _this.$services.append("<option value='"+ list[i] + "'>" + list[i] + "</option>")
            }
        });
    },
    list_voyage: function(vessel){
        var _this = this;
        var url = '/api/v1/results/week/list_voyage?vessel='+vessel;
        $.get(url).done(function(json){
            var list = json.list;
            _this.$voyage.empty().append("<option>- Selected -</option>");
            for(i=0; i < list.length; i++){
                _this.$voyage.append("<option value='"+ list[i] + "'>" + list[i] + "</option>")
            }
        });
    },
    list_origin: function(vessel){
        var _this = this;
        var url = '/api/v1/results/week/list_origin?vessel=' + vessel;
        $.get(url).done(function(json){
            var list = json.list;
            _this.$origin.empty().append("<option>- Selected -</option>");
            _this.$destination.empty().append("<option>- Selected -</option>");
            for(i=0; i < list.length; i++){
                _this.$origin.append("<option value='"+ list[i] + "'>" + list[i] + "</option>")
            }
            _this.bind_origin();
        });
    },
    list_destination: function(origin){
        var _this = this;
        var url = '/api/v1/results/week/list_destination?origin=' + origin;
        $.get(url).done(function(json){
            var list = json.list;
            _this.$destination.empty().append("<option>- Selected -</option>");
            for(i=0; i < list.length; i++){
                _this.$destination.append("<option value='"+ list[i] + "'>" + list[i] + "</option>")
            }
        });
    },
    list_month: function(){
        var _this = this;
        var url = '/api/v1/results/week/list_month';
        $.get(url).done(function(json){
            var list = json.list;
            _this.$month.empty().append("<option>- Selected -</option>");
            for(i=0; i < list.length; i++){
                _this.$month.append("<option value='"+ list[i] + "'>" + list[i] + "</option>")
            }
        });
    },
    bind_vessel: function(){
        var _this = this;
        _this.$vessel.bind('change', function(){
            var $this = $(this);
            _this.list_voyage($this.val());
            _this.list_origin($this.val());
        });
    },
    bind_origin: function(){
        var _this = this;
        _this.$origin.bind('change', function(){
            var $this = $(this);
            _this.list_destination($this.val());
        });
    },
    bind_search: function(){
        var _this = this;
        _this.$btn_search.bind('click', function(){
              var url = '/api/v1/results/week/search';
            $.getJSON(url).done(function(json){
                console.log(json);
            });
        });
    }
};