
$(function(){

	selectTab();

	// Number all tabs and tab content areas so that we can switch all code areas between swift and objective-c
	var index = 0;
	$('a[href*="swift"]').each(function (e) {
		// number the href
	  $(this).attr('href', $(this).attr('href') + index);
	  // also number the id of the content element
	  var content = $(this).parent().parent().next().find('#swift');
	  content.attr('id', content.attr('id') + index);

	  index += 1
	});

	// Do the same for objective-c
	index = 0;
	$('a[href*="objc"]').each(function (e) {
		// number the href
	  $(this).attr('href', $(this).attr('href') + index);
	  // also number the id of the content element
	  var content = $(this).parent().parent().next().find('#objc');
	  content.attr('id', content.attr('id') + index);
	  
	  index += 1
	});

	// when swift/objective-c tab clicked, swap tabs on each element on screen
	$('a[href*="objc"]').click(function (e) {
	  e.preventDefault()
	  $('a[href*="objc"]').each(function(){
		$(this).tab('show');
	  });
	});

	$('a[href*="swift"]').click(function (e) {
	  e.preventDefault()
	  $('a[href*="swift"]').each(function(){
		$(this).tab('show');
	  });
	});
	
});

function selectTab() {

	var tabName = "{{ page.title }}";
	
	$('.nav-link.active').removeClass('active');
	var nav_link = $('.nav-link:contains("' + tabName + '")');
	nav_link.addClass('active');
	nav_link.parents('.collapse').each(function(){
		$(this).attr('class', $(this).attr('class') + "in");
	});

}

function setInstallationText(module) {

	var text = "pod 'BVSDK'\n";
	switch(module) {
		case "recommendations":
			text += "pod 'BVSDK/BVRecommendations"
			break;
		case "advertising":
			text += "pod 'BVSDK/BVAdvertising"
			break;
		case "curations":
			text += "pod 'BVSDK/BVCurations'\n"
			text += "pod 'SDWebImage' # Used to load images asynchronously"
			break;
		case 'conversations':
			break;
		case 'bv_pixel':
			break;
	}
	$('#installation_placeholder').text(text);

	$('pre code').each(function(i, block) {
		hljs.highlightBlock(block);
	});
}