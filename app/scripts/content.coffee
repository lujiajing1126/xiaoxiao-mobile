$ ->
	namespace = window.XXWEB.namespace
	userSession = localStorage.getItem "userSession"
	window.auth()
	.then ->
		userId = localStorage.getItem "userId"
		Q $.ajax
			url: "#{namespace}user/#{userId}/info?session=#{userSession}&fields=#{window.XXWEB.userInfoFields.join(',')}",
			type: 'get',
			dataType: 'json'
	.then (data)->
		console.log data
		window.AppUser = $.extend data.userInfo, data.dynamic
	.then ->
		eventId = location.hash.match(/([a-z0-9]{24})/i)[1]
		fields = ["name","location","category","description","begin","end","numberOfPeople","numberOfPreservedSeats","organizationName","organizationId","signingUpFields","poster"]
		fieldStr = fields.join ","
		Q $.ajax
			url: "#{namespace}event/#{eventId}/load?session=#{userSession}&fields=#{fieldStr}"
			dataType: 'json'
	.then (data)->
		console.log data
	, (err) ->
		console.log "~~~"
	.done ->
		setTimeout ->
			$("#appLoadingIndicator").hide()
			$("html,body").css "background-color","transparent"
			$(".wrap").show()
		,2000