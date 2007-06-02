var star_on = new Image;
var star_off = new Image;
var mail_on = new Image;
var mail_off = new Image;

star_on.src = "/images/star_on.png";
star_off.src = "/images/star_off.png";
mail_on.src = "/images/mail_on.png";
mail_off.src = "/images/mail_off.png";

window.onload = function () {
	accordion = new fx.Accordion(document.getElementsByClassName('swap_title'), 
								 document.getElementsByClassName('swap_list'), 
								{ opacity: false,
								  duration: 250 } );
	$$("span.username_hover").each( function(link) {
		new Tooltip(link, {mouseFollow: false});
	});
}

var Spinner = {}

Spinner = {
    hide_element: function(element) {
        Effect.Fade($(element), { duration:0.3, to:0.2, queue:'front'})
    },
    
    show_element: function(element) {
        Effect.Appear($(element), { duration:0.3, to:0.999999, queue:'end' } );
        /* to: fixes weird display issues in Safari */
        Effect.Opacity($(element), { to:1, queue:'end' } );
    }
}