$ ->
	window.auth()
	.then ->
		Q $.ajax
			url: window.XXWEB.namespace + 'user/' + localStorage.getItem("userId") + '/info?session=' + localStorage.getItem("userSession") + '&fields=' + window.XXWEB.userInfoFields.join(','),
			type: 'get',
			dataType: 'json'
	.then (data)->
		console.log data
		window.AppUser = $.extend data.userInfo, data.dynamic
	.then ->
		boardName = "复旦诗社"
		Q $.ajax
			url: window.XXWEB.namespace + 'event_board/' + encodeURI(boardName) + '/list_published_events?session=' + localStorage.getItem("userSession") + '&skip=0&limit=10'
			dataType: 'json'
	.then (data)->
		console.log data
	.done()
	$(document).on "click","span.logout", ->
		location.href = window.XXWEB.loginpage