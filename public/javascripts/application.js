// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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