function show_menu() {
    $('#mobile-overlay').show();    
}
function hide_menu() {
    $('#mobile-overlay').hide();    
}
function isMobile() {
    return $(window).width <= 400 ;
}

function make_side_panel() {
    
}

function toggle_sidebar() {
    if (isMobile()) {
        make_side_panel();
    }
}



$(document).ready(function () {
    $('#menu-button').click(function (){
        show_menu();
    });
    $('#mobile-overlay').click(function() {
        hide_menu();
    });
    toggle_sidebar();
});
