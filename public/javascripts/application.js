var star_on = new Image();
var star_off = new Image();
var mail_on = new Image();
var mail_off = new Image();

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
        
        new Effect.Parallel(
            [ new Effect.Fade($(element), { to:0.2 }) ],
            [ new Effect.Appear($('spinner'), { to:0.999999 }) ],
            { queue:'front' }
            )
    },
    
    show_element: function(element) {
        new Effect.Parallel(
            [ new Effect.Appear($(element), { to:0.9999999 }) ],
            [ new Effect.Fade($('spinner')) ],
            { queue:'end' }
            ); 
        /* to: fixes weird display issues in Safari */
    }
}

var Rf = {} 

Rf = {
    resetform: function(name) {
        $('invite_to').value = 'myfriend@mixopotamus.com';
        $('invite_message').value = "Hi friend,\n\nHave you ever received a great mix from a friend? How about a total stranger? You can get both if you join me at Mixopotamus, a simple mix swapping project. You'll exchange an original mix CD with 5 other people, selected at random.\n\nWhat will your mix say about you? And to whom? Who knows. But I know you've got great taste in music--why not share it with others and discover some great new stuff while you're at it?\n\nHappy mixing!\n" + name;
    }
}