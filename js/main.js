/*Copyright (c) Chedy Missaoui All rights reserved.*/
/*Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.*/
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
    $('nav#site-nav').show();
}

function toggle_sidebar() {
    if (isMobile()) {
        make_side_panel();
    }
}

function mark_selected_menu_item() {
    var selectedId = '#' + $('span.page-marker').data('menu-item');
    $(selectedId).addClass('selected');
    //WARNING hard coded style!!!
    $(selectedId + ' button').css({'color': 'white'});
}
function short_content() {
    var docHeight = $(document).height();
    var screenHeight = screen.height;
    return (docHeight / screenHeight) < 2.5;
}
function inViews(views) {
    var selected = $('span.page-marker').data('menu-item');
    console.log(selected);
    return views.includes(selected);
}
$(document).ready(function () {
    $('button#scroll-top').click(function(){
        $('body,html').animate({
                          scrollTop: 0
                        }, 1000);
        return false;
    });
    if (short_content() || inViews(['bestiaire', 'about'])) {
        $('button#scroll-top').hide();
    }
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
            }
    );
    toggle_sidebar();
    mark_selected_menu_item();
});
