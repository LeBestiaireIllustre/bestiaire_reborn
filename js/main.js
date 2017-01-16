var mobileMenuWidth = '15.5em';

function show_menu() {
    $('#mobile-overlay').show();
    $('#mobile-menu-container').animate({
        'right': '0em'
    }, 400);
    $('html,body').addClass('noscroll');
}

function hide_menu() {
    $('#mobile-overlay').hide();
    $('#mobile-menu-container').animate({
        'right': '-' + mobileMenuWidth
    }, 400);
    $('html,body').removeClass('noscroll');
}

function isMobile() {
    return $(window).width() <= 640 ;
}

function make_side_panel() {
    $('#mobile-menu-container').append($('#site-nav'));    
    $('#mobile-menu-container').append($('#side-bar'));    
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
    $('div.bestiaire img.bestiaire-image').hover(
            function(){
                $('#mobile-overlay').show();
            }, 
            function(){
                $('#mobile-overlay').hide();
            });    
    toggle_sidebar();
});
