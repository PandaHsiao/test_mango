/**
 * Created with JetBrains RubyMine.
 * User: panda
 * Date: 3/26/14
 * Time: 11:19 AM
 * To change this template use File | Settings | File Templates.
 */

//= require jquery
//= require jquery_ujs
//= require kendo/kendo.web.min
//= require jquery.ui.sortable


//========================================================
// 開啟建立類別畫面 this btn in category_list partial view
//========================================================
function bind_event(){
    $("#new_category").on("click", function(){
        $.get('/home/create_category.json').done(function(response){
            //location.href = '/home/create_category';
            $("#ti1_sub a.now").removeClass('now');
            $("#sub_category_create").addClass('now')
            var state = {url:'/home/create_category'};
            window.history.pushState(state,'', '/home/create_category');
            $("#right_partial").html(response.partial);
        }).fail(function(){ alert('oops! 出現錯誤了!') });
    });

//    $("#sub_category_list").on("click", function(){
//        var t = $(this);
//        $.get('/home/index.json').done(function(response){
//            //location.href = '/home/create_category';
//            $("#ti1_sub a.now").removeClass('now');
//            t.addClass('now')
//            var state = {url:'/home/index'};
//            window.history.pushState(state,'', '/home/index');
//            $("#right_partial").html(response.partial);
//            bind_event();
//        }).fail(function(){ alert('oops! 出現錯誤了!') });
//    });

//    $("#sub_category_create").on("click", function(){
//        var t = $(this);
//        $.get('/home/create_category.json').done(function(response){
//            $("#ti1_sub a.now").removeClass('now');
//            t.addClass('now')
//            var state = {url:'/home/create_category'};
//            window.history.pushState(state,'', '/home/create_category');
//            $("#right_partial").html(response.partial);
//            //bind_event();
//        }).fail(function(){ alert('oops! 出現錯誤了!') });
//    })
};

window.addEventListener('popstate', function(e){
    if (history.state){
        var state = e.state;

        $.get(state.url + '.json').done(function(response){
            //var state_hash = {url:state.url};
            //window.history.pushState(state_hash,'', state.url);

            switch_sidebar(state.url );

            $("#right_partial").html(response.partial);
            bind_event();
        }).fail(function(){ alert('oops! 出現錯誤了!') });
    } else {
        //history.replaceState({ url: window.location.href }, '');
    }
}, false);


function switch_sidebar(url){
    $("#left_sidebar a.now").removeClass('now');
    $(".sub_choice a.now").removeClass('now');

    if (url == '/home/index') {
        $("#ti1").addClass('now');
        $("#sub_category_list").addClass('now');
    } else if (url == '/home/create_category'){
        $("#ti1").addClass('now');
        $("#sub_category_create").addClass('now');
    }

};

$(function(){
    $("#ti1").addClass('now');
    $("#sub_category_list").addClass('now');
    bind_event();
});