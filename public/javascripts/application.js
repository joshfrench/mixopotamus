var star_on = new Image;
var star_off = new Image;
var mail_on = new Image;
var mail_off = new Image;

star_on.src = "/images/star_on.png";
star_off.src = "/images/star_off.png";
mail_on.src = "/images/mail_on.png";
mail_off.src = "/images/mail_off.png";

window.onload = function () {
	accordion = new fx.Accordion(document.getElementsByClassName('tog'), 
								 document.getElementsByClassName('el'), 
								{ opacity: false,
								  duration: 350 } );
}