$(function () {
	$('.dropdown-toggle').hover(function() {
		$('.dropdown-menu').show();
	}, function () {
		$('.dropdown-menu').hide('slow');
	});

	$('.dropdown-menu').hover(function() {
		$('.dropdown-menu').stop(true, true).show();
	}, function () {
		$('.dropdown-menu').hide();
	});
});