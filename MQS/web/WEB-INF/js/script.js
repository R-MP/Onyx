$(function(){
	var nav_offset_top = $('header').height() + 50; 
	function navbarFixed(){
		if ( $('.header_one').length ){ 
			$(window).scroll(function() {
				var scroll = $(window).scrollTop();   
				if (scroll >= nav_offset_top ) {
					$(".header_one").addClass("navbar_fixed");
				} else {
					$(".header_one").removeClass("navbar_fixed");
				}
			});
		};
	};
	navbarFixed();

	var page = $('html, body'); 
	$('a.nav-link').click(function(){
		page.animate({
			scrollTop: $( $.attr(this, 'href') ).offset().top
		}, 900);
		return false;
	});
	var page = $('html, body'); 
	$('a.navbar-brand').click(function(){
		page.animate({
			scrollTop: $( $.attr(this, 'href') ).offset().top
		}, 900);
		return false;
	});
});

