//= require admin/ga
//= require admin/bootstrap-switch

var Users = {
    $table_users: $('#table-users'),
    $table_users_tbody: $('#table-users-tbody'),
    $role: $('#role'),
    init: function(){
        var _this = this;
        _this.index();
        _this.fill_roles();
    },
    fill_roles: function(){
        var _this = this;
        var url = '/api/v1/main/roles';
        $.getJSON(url).complete(function(response){
            if (response.status==200){
                var roles = response.responseJSON.roles;
                _this.$role.empty().append('<option value=""></option>');
                for(var i = 0; i< roles.length; i++){
                    _this.$role.append('<option value="' + roles[i].id + '">' + roles[i].name + '</option>');
                }
            }
        });
    },
    index: function(){
        var _this = this;
        var url = '/api/v1/main/users'
        $.getJSON(url).done(function(json){
            var set_html = [];
            $.each(json.users, function(k, v){
                set_html.push('<tr>');
                set_html.push('<td>' + v.name + '</td>');
                set_html.push('<td>' + v.email + '</td>');
                set_html.push('<td>' + v.created_at + '</td>');
                set_html.push('<td>' + v.activated + '</td>');
                set_html.push('<td>E</td>');
                set_html.push('<td>D</td>');
                set_html.push('</tr>');
            });
            _this.$table_users_tbody.empty().append(set_html.join(','));
        })
    }
};