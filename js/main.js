function show_menu() {
    $('#mobile-overlay').show();
}
function hide_menu() {
    $('#mobile-overlay').hide();    
}
function isMobile() {
    return $(window).width() <= 400 ;
}

function make_side_panel() {
    $('#mobile-menu-container').append($('#site-nav'));    
    $('#mobile-menu-container').append($('#side-bar'));    
}
function set_menu_button_position() {

}
function set_page_container_padding_top() {

}
function toggle_sidebar() {
    if (isMobile()) {
        make_side_panel();
    }
    set_menu_button_position();
    set_page_container_padding_top();
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
