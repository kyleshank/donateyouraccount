//= require jquery  
//= require jquery_ujs  
//= require_self  
//= require_tree . 

$(function(){
    $("textarea.embed").click(function(){
        $(this).focus();
        $(this).select();
    });
    $("#new_twitter_status .messages li").click(function(){
        $("#twitter_status_uid").val($(this).attr("twitter-id"));
        $(".messages li").removeClass("selected");
        $(this).addClass("selected");
    });
    $("#new_facebook_status .messages li").click(function(){
        $("#facebook_status_uid").val($(this).attr("facebook-id"));
        $(".messages li").removeClass("selected");
        $(this).addClass("selected");
    });
});