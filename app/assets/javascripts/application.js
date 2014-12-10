// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require turbolinks
// require_tree .


window.validate = function(form) {
    var check;
    check = true;
    if ($(form).attr('id') === 'devise_edit') {
        return check;
    }
    $(form).find('.invalid').removeClass('invalid');
    $(form).find('input').each(function() {
        var _this;
        _this = $(this);
        if (_this.is('[required]')) {
            if (this.value === '') {
                _this.addClass('invalid');
                check = false;
            }
        }
        if (_this.attr('type') === 'email') {
            if (!this.value.match(/[\w|.]+@[\w|.]+$/)) {
                _this.addClass('invalid');
                check = false;
            }
        }
        if (_this.data('type') === 'date') {
            if ((new Date(this.value)).toString() === 'Invalid Date') {
                _this.addClass('invalid');
                check = false;
            }
        }
        if (_this.attr('type') === 'url') {
            if (!this.value.match(/^http(s?):\/\/[\w|.]+$/)) {
                _this.addClass('invalid');
                check = false;
            }
        }
        if (_this.attr('type') === 'password') {
            if (!(this.value.length > 6)) {
                _this.addClass('invalid');
                return check = false;
            }
        }
    });
    $(form).find(':checkbox').each(function() {
        var _this;
        _this = $(this);
        if (_this.is('[required]')) {
            if (!_this.is(':checked')) {
                _this.addClass('invalid');
                return check = false;
            }
        }
    });
    $(form).find('select').each(function() {
        var _this;
        _this = $(this);
        if (_this.is('[required]')) {
            if (this.value === '') {
                _this.addClass('invalid');
                return check = false;
            }
        }
    });
    return check;
};


