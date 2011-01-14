// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function(){
    /** Buttons **/
    $(".button").mousedown(function(e){
        e.preventDefault();
        $(this).addClass("mousedown");
    });
    $(".button").bind("mouseup mouseleave", function(e){
        e.preventDefault();
        $(this).removeClass("mousedown");
    });
    $(".button").mousemove(function(e){
        e.preventDefault();
        return false;
    });
});