
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
    toggle_sidebar();
});
