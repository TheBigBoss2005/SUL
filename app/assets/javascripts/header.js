$(document).on('ready page:load', function () {
	$('#navbarToggle').on('click', function(e) {
		if( $('#navbar').hasClass('hide') ) {
			$('#navbar').removeClass('hide');
		} else {
			$('#navbar').addClass('hide');
		}
	});
});