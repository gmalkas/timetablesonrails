// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//
function toggle(button) {
	img = button.children("img");
	details = button.siblings(".details");
	visible = details.is(':visible');
	details.toggle();

	prefix = ''; 

	if(button.parent().hasClass('valid') || button.parent().hasClass('warning')) {
		prefix = 'white_';
	}

	if(!visible) {
		img.attr('src', '/assets/' + prefix + 'minus_alt_16x16.png');
		img.attr('alt', '-');
	}else {
		img.attr('src', '/assets/' + prefix + 'plus_alt_16x16.png');
		img.attr('alt', '+');
	}
}

$(document).ready(function() {
	$( ".plus" ).click(function() {
		toggle($(this));
		return false;
	});

	$(".show_form").click(function() {
		$(this).addClass("disable");
    $(this).parent().siblings("form").fadeIn(350);
		$(this).parent().siblings("form").find(".form_name").focus();
		return false;
	});

	$(".cancel").click(function() {
    $(this).parents("form").fadeOut(250);
		$(this).parents("form").siblings(".add-course").children(".show_form").removeClass("disable");
		return false;
	});

	$(".show_teacher_card").click(function() {
    $(".teacher_card").fadeIn(250);
		return false;
	});

	$(".close_card").click(function() {
    $(".teacher_card").fadeOut(250);
		return false;
	});
});

$(document).ready(function() {
  $('.nav-tools').hover(function() { $(this).fadeTo(200, 1); }, function() { $(this).fadeTo(500, 0.3); });
});
