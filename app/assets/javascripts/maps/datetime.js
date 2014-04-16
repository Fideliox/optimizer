//= require datetimepicker/bootstrap-datetimepicker.es
//= require datetimepicker/bootstrap-datetimepicker.min
//= require moment/moment.min

var DateTime = {
    $_start_date: $('#start_datetimepicker'),
    $_end_date: $('#end_datetimepicker'),
    $_prev_start_date_btn: $('#prev_start_date_btn'),
    $_next_start_date_btn: $('#next_start_date_btn'),
    $_prev_end_date_btn: $('#prev_end_date_btn'),
    $_next_end_date_btn: $('#next_end_date_btn'),
    init: function(){
        var _this = this;
        _this._set_start_date();
        _this._set_end_date();
        _this._click_start_date();
        _this._click_end_date();
        _this.$_start_date.val(moment(_this.$_start_date.val(), "DD-MM-YYYY").subtract('d', 90).format("DD-MM-YYYY")).change();
    },
    _set_start_date: function(){
        var _this = this;
        _this.$_start_date.val(moment().format("DD-MM-YYYY")).datetimepicker({
            minView: 2,
            autoclose: true,
            language: 'en',
            todayBtn: true,
            initialDate: new Date(),
            format: 'dd-mm-yyyy',
            pickerPosition: 'bottom-left',
            weekStart: 1
        });
    },
    _set_end_date: function(){
        var _this = this;
        _this.$_end_date.val(moment().format("DD-MM-YYYY")).datetimepicker({
            minView: 2,
            autoclose: true,
            todayBtn: true,
            language: 'en',
            initialDate: new Date(),
            format: 'dd-mm-yyyy',
            pickerPosition: 'bottom-left',
            weekStart: 1
        });
    },
    _click_start_date: function(){
        var _this = this;
        _this.$_prev_start_date_btn.on("click", function(e) {
            _this.$_start_date.val(moment(_this.$_start_date.val(), "DD-MM-YYYY").subtract('d', 1).format("DD-MM-YYYY")).change();
        });
        _this.$_next_start_date_btn.on("click", function(e) {
            _this.$_start_date.val(moment(_this.$_start_date.val(), "DD-MM-YYYY").add('d', 1).format("DD-MM-YYYY")).change();
        });
    },
    _click_end_date: function(){
        var _this = this;
        _this.$_prev_end_date_btn.on("click", function(e) {
            _this.$_end_date.val(moment(_this.$_end_date.val(), "DD-MM-YYYY").subtract('d', 1).format("DD-MM-YYYY")).change();
        });
        _this.$_next_end_date_btn.on("click", function(e) {
            _this.$_end_date.val(moment(_this.$_end_date.val(), "DD-MM-YYYY").add('d', 1).format("DD-MM-YYYY")).change();
        });
    }
};