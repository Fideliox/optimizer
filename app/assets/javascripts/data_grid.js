//= require twitter/bootstrap/modal
//= require twitter/bootstrap/tab
//= require twitter/bootstrap/tooltip
//= require select2-3.3.2/select2
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap

;(function($,window,undefined){
    $.fn.dg = function(obj){
        var table = obj.table;
        var icon_new_html = obj.icon_new_html;
        var icon_new_id = obj.icon_new_id;
        var modal = obj.modal;
        var modal_content = obj.modal_content;
        var v_id = 0;
        var $tab_first = $('#myTab > li > a:first');
        var $form = $('.form-control');
        var oTable = $(table).dataTable({
            "oLanguage": {
                "sUrl": obj.language
            }
        });
        setTimeout(function(){
            $(".dataTables_filter label").append(icon_new_html);
            $('.tooltip_status').tooltip();
            $(icon_new_id).click(function(){
                $("#btn-save").show();
                $(modal_content).load(controller + "/new", function(){
                    $("#btn-save").data('method', 'POST');
                });
                $(modal).modal('show');
            });
        }, 1000);
        $(modal).on('hidden.bs.modal', function () {
            $(modal_content).html('');
            $("#tr-dg-" + v_id).removeClass('dg-text-error');
        });
        return {
            open_link: function(id, url){
                $("#tr-dg-" + id).addClass('dg-text-error');
                $(modal_content).load(url);
                $(modal).modal('show');
                $("#btn-save").hide();
            },
            show: function(id){
                v_id = id;
                $("#tr-dg-" + id).addClass('dg-text-error');
                $(modal_content).load(controller + "/" + id);
                $(modal).modal('show');
                $("#btn-save").hide();
            },
            edit: function(id, fields){
                v_id = id;
                $("#tr-dg-" + id).addClass('dg-text-error');
                $("#btn-save").show();
                $(modal_content).load(controller + "/" + id + "/edit");
                $(modal).modal('show');
                $("#btn-save").data('method', 'PUT');
                $("#btn-save").data('object', id);
                $("#btn-close").data('object', id);
                $('#myTab > li > a').tab('show')
            },
            delete: function(id){
                v_id = id;
                $("#tr-dg-" + id).addClass('dg-text-error');
                bootbox.confirm(dg_msg_delete, function(answer){
                    if (answer){
                        var url = controller + '/' + id;
                        $.ajax({
                            type: 'DELETE',
                            url: url,
                            contentType: "application/json"
                        }).done(function(data){
                                if (data.status){;
                                    oTable.fnDeleteRow(oTable.fnGetPosition($("#tr-dg-" + data.id).get(0)));
                                    $(modal).modal('hide');
                                }else{
                                    bootbox.alert("Error <span class='dg-text-error'>" + data.errors.original_exception.error_number + "</span>, consulte con su administrador.");
                                }
                            });
                    }else{
                        $("#tr-dg-" + v_id).removeClass('dg-text-error');
                    }
                });
            },
            close: function(){
                $(modal).modal('hide');
            },
            save: function(method, fields, op){
                var attr = {};
                var _that = this;
                var _object = $("#btn-save").data("object");
                var $form = $('.form-control');
                $form.each(function(){
                    if($(this).attr('id').indexOf("s2id_")){
                        if($(this).is('input:checkbox')){
                            attr[$(this).attr("id")] = $(this).is(":checked") ? 1:0;
                        }else{
                            attr[$(this).attr("id")] = $(this).val();
                        }
                    }
                });
                var _url = method == 'POST' ? controller : controller + '/' + _object;
                $.ajax({
                    type: method,
                    url: _url,
                    contentType: "application/json",
                    data: JSON.stringify(attr)
                }).done(function(data){
                        if (data.status){
                            if (method == 'POST'){
                                var row = [];
                                $.each(fields, function(k, v ){
                                    row.push(eval("data." + v));
                                });
                                var arr = _that.options(op, data.id);
                                if(!!arr.show) row.push(arr.show);
                                if(!!arr.edit) row.push(arr.edit);
                                if(!!arr.delete) row.push(arr.delete);
                                var a = oTable.fnAddData(row);
                                var tr = oTable.fnSettings().aoData[ a[0] ].nTr;
                                var i = 0;
                                $.each(fields, function(k, v ){
                                    $($(tr).children("td").get(i++)).attr('id', 'td-dg-' + v + "-" +  data.id);
                                });
                                $(tr).addClass('text-success');
                                $(tr).attr("id", "tr-dg-" + data.id);
                                $('.tooltip_status').tooltip();

                                $.each(fields, function(k, v ){
                                    $("#td-dg-" + v + "-" + data.id).html(eval("data." + v));
                                });
                            }else{
                                $.each(fields, function(k, v ){
                                    $("#td-dg-" + v + "-" + data.id).html(eval("data." + v));
                                });
                            }
                            $("#tr-dg-" + data.id).addClass('text-success');
                            $(modal).modal('hide');
                            $(table).dataTable();
                            $('.img-show').unbind('click');
                            $('.img-show').bind('click', function(){
                                _that.show($(this).data('object'));
                            });
                            $('.img-edit').unbind('click');
                            $('.img-edit').bind('click', function(){
                                _that.edit($(this).data('object'), fields);
                            })
                            $(".img-delete").unbind('click');
                            $(".img-delete").click(function(){
                                _that.delete($(this).data('object'));
                            });
                        }else{
                            $(modal).hide();
                            bootbox.alert("Error <span class='dg-text-error'>" + data.errors.original_exception.error_number + "</span>, consulte con su administrador.", function() {
                                $(modal).show();
                            });
                        }
                    });
            },
            options: function(op, id){
                var arr = [];
                var arr_img = {};
                $.each(op, function(key, value){
                    arr = value.replace("]", "").replace(":","").replace("[","").replace(" ","").split(",");
                    if(arr[1] == "true"){
                        switch(arr[0]){
                            case 'show':
                                arr_img.show = "<div class='text-center'>" + image_show.replace('X', id) + "</div>";
                                break;
                            case 'edit':
                                arr_img.edit = "<div class='text-center'>" + image_edit.replace('X', id) + "</div>";
                                break;
                            case 'delete':
                                arr_img.delete = "<div class='text-center'>" + image_delete.replace('X', id) + "</div>";
                                break;
                        }
                    }
                });
                return arr_img;
            }
        }
    }
})(jQuery, window);