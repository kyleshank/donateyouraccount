//= require jquery  
//= require jquery_ujs  
//= require_tree . 

$(function(){
    $("textarea.embed").click(function(){
        $(this).focus();
        $(this).select();
    });
    $("#new_twitter_status .messages tr").click(function(){
        $("#twitter_status_uid").val($(this).attr("twitter-id"));
        $(".messages tr").removeClass("success");
        $(this).addClass("success");
    });
    $("#new_facebook_status .messages tr").click(function(){
        $("#facebook_status_uid").val($(this).attr("facebook-id"));
        $(".messages tr").removeClass("success");
        $(this).addClass("success");
    });
});