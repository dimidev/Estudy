// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery2
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require jquery-fileupload
//= require bootstrap-sprockets
//= require jquery_nested_form
//= require icheck
//= require moment
//= require moment/el
//= require bootstrap-datetimepicker
//= require pickers
//= require ahoy
//= require underscore
//= require bootstrap-select.min
//= require bootstrap-toggle.min
//= require ckeditor/init
//= require datatables
//= require fullcalendar
//= require calendars

$(function(){
    // Full Height main section
    if(!$('body').hasClass('devise')){
        var main_height = $(document).outerHeight(true) - $('header').outerHeight(true) - $('footer').outerHeight(true);
        $('main .wrapper').css('min-height',main_height);
    }

    // Bootstrap Tooltip init
    $('[data-toggle="tooltip"]').tooltip();
    // Tooltip on appended elements
    $(document).tooltip({selector: '[data-toggle="tooltip"]'});

    // Bootstrap Popover init
    $('[data-toggle="popover"]').popover();
    // popover on appended elements
    $(document).popover({selector: '[data-toggle="popover"]'});

    // Init Bootstrap Selectors
    $('select').selectpicker();

    // Init datetimepicker
    $('.datetimepicker').datetimepicker();

    $(document).on('click', '.btn.add_nested_fields', function(){
        $('.datetimepicker').datetimepicker();
    });

    // image preview (logo or avatar)
    var preview = $('#avatar-img');
    $('#avatar-upload').change(function(event){
        var input = $(event.currentTarget);
        var file = input[0].files[0];
        var render = new FileReader();
        render.onload = function(e){
            image_base64 = e.target.result;
            preview.attr('src',image_base64);
        };
        render.readAsDataURL(file);
        $('#delete_img').val(0);
    });

    // Delete logo or avatar
    $('#avatar-delete').click(function(){
        $('#avatar-img').removeAttr('src').removeAttr('alt');
        $('#avatar-upload').val('');
        $('#delete_img').val(1);
    });

    // function for sidebar collapse
    $('#sidebar .nav').on('click','li',function(){
        if($(this).is('.expand')){
            $(this).removeClass('expand').children('ul').slideUp('fast');
        } else if ($(this).hasClass('has-sub')) {
            $('#sidebar').find('.expand').removeClass('expand').children('ul').slideUp('fast');
            $(this).addClass('expand').children('ul').slideDown('fast');
        }
    });

    // Init icheck plugin
    function icheck(){
        if($(".icheck").length > 0){
            $(".icheck").each(function(){
                var $el = $(this);
                var opt = {
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_circle-blue'
                };
                $el.iCheck(opt);
            });
        }
    }
    icheck();

    // Init icheck on appended elements through nested form
    $(document).on('click','.btn.add_nested_fields', function(){
        $('.icheck').iCheck({checkboxClass: 'icheckbox_square-blue'});
        $("select").selectpicker('refresh');
    });
});