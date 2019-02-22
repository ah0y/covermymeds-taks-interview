// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

$('[data-toggle="collapse"]').on('click', function() {
    $(this).toggleClass('collapsed');
});

$('#siteColor').change(()=>{
    $("#full").css("background-color",$("#siteColor").val());
    localStorage.setItem('siteColor', $("#siteColor").val() );
});

$(document).ready(function(){
    var siteColor = localStorage.getItem("siteColor")
    if (siteColor != "#FFFFFF") {
        $("#full").css("background-color",siteColor);
    }
});

var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };

$(".start_time").text(function() {
   return new Date($(this).text()).toLocaleString("en-US", options)
});




// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"



