var Results = {
    init: function(){
        var _this = this;
        _this.bind_refresh();
        _this.task_demand('generate_xlsx');
        _this.task_demand('empty_od_xlsx');
    },
    bind_refresh: function(){
        var _this = this;
        var $btn_refresh = $('.btn-refresh');
        $btn_refresh.bind('click', function(){
            var $this = $(this);
            var url = '';
            if($this.data('process') == 'generate_xlsx'){
                url = '/api/v1/results/demands/generate_xlsx';
            }else if($this.data('process') == 'empty_od_xlsx'){
                url = '/api/v1/results/empty_od/empty_xlsx';
            }
            bootbox.confirm('Do you want to generate the file?', function(result) {
                if(result){
                    $.get(url).complete(function(response){
                        if (response.status==200){
                            if($this.data('process') == 'generate_xlsx'){
                                setTimeout(function(){ _this.task_demand($this.data('process')); }, 3000);
                            }else if($this.data('process') == 'empty_od_xlsx'){
                                setTimeout(function(){ _this.task_empty($this.data('process')); }, 500);
                            }
                        }else{
                            console.error('Error');
                        }
                    });
                }
            });
        });
    },
    task_empty: function(process){
        var _this = this;
        var url = '/api/v1/process/empty_od/status_xlsx?process=' + process;
        var $bar_empty = $('#bar-empty');
        if (!$bar_empty.parent().hasClass('active')){
            $bar_empty.parent().addClass('active');
        }
        $.get(url).complete(function(response){
            if (response.status==200){
                $bar_empty.width(response.responseJSON.percentage + '%');
                if (response.responseJSON.percentage != 100){
                    setTimeout(function(){ _this.task_empty(process); }, 2000);
                }else{
                    $bar_empty.parent().removeClass('active');
                }
            }else{
                console.error(response);
                $bar_empty.parent().removeClass('active');
            }
        });
    },
    task_demand: function(process){
        var _this = this;
        var url = '/api/v1/process/iz_files/status_xlsx?process=' + process;
        var $bar_demand = $('#bar-demand');
        if (!$bar_demand.parent().hasClass('active')){
            $bar_demand.parent().addClass('active');
        }
        $.get(url).complete(function(response){
            if (response.status==200){
                $bar_demand.width(response.responseJSON.percentage + '%');
                if (response.responseJSON.percentage != 100){
                    setTimeout(function(){ _this.task_demand(process); }, 2000);
                }else{
                    $bar_demand.parent().removeClass('active');
                }
            }else{
                console.error(response);
                $bar_demand.parent().removeClass('active');
            }
        });
    }
};