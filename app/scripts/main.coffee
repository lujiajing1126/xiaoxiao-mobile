$ ->
	ongoingMove = 
		beginX: null
		beginY: null
		endX: null
		endY: null
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
		$("#eventCardBoard").html template "eventCard",{events:data.events} if data.status is "OK"
	, (err) ->
		console.log "~~~"
	.done ->
		setTimeout ->
			# 设置主层级的高度并显示
			$("div.mainLayout").css 'height',$(window).height()
			.show()
			$("#appLoadingIndicator").hide()
			$("html,body").css "background-color","transparent"
			reCalBackgroundPosition()
			$(".userPanel").show()
			$("body").css
				"background-image": "url(images/background.jpg)"
		,2000
	$(document).on "click","span.logout", ->
		location.href = window.XXWEB.loginpage
	# 重新計算背景圖片偏移量
	reCalBackgroundPosition = ->
		$("div.eventCard").each (k,v)->
			_self = $(v)
			relativeHeight = _self.offset().top + _self.height()/2 - $(".mainLayout").height()/2 - $(window).scrollTop() + 200
			value = "50% "+(-relativeHeight/20)+"px"
			_self.css
				"background-position": value
	reCalAnimation = (options)->
		ongoingMove.beginX ?= 0
		ongoingMove.beginY ?= 0
		ongoingMove.endX ?= 0
		ongoingMove.endY ?= 0
		if Math.abs(ongoingMove.beginY - ongoingMove.endY) < 20 and ongoingMove.endX - ongoingMove.beginX > 50 or !!options
			scaleSize = 1-(ongoingMove.endX - ongoingMove.beginX)/1000
			scaleUserPanel = 0.2*(ongoingMove.endX - ongoingMove.beginX)/240 + 0.8
			leftMove = -100 + 100*(ongoingMove.endX - ongoingMove.beginX)/240
			$(".mainLayout").css
				left: ongoingMove.endX - ongoingMove.beginX
				transform: "scale(#{scaleSize})"
			$(".userPanel").css
				opacity: 0.2+ (ongoingMove.endX - ongoingMove.beginX)/240*0.8
				transform: "scale(#{scaleUserPanel})"
				left: "#{leftMove}px"
	$(".mainLayout").scroll ->
		reCalBackgroundPosition()
	$(window).on "touchstart", (evt)->
		ongoingMove.beginX = evt.originalEvent.changedTouches[0].clientX
		ongoingMove.beginY = evt.originalEvent.changedTouches[0].clientY
	$(window).on "touchmove", (evt)->
		window.XXWEB.throttle ->
			ongoingMove.endX = evt.originalEvent.changedTouches[0].clientX
			ongoingMove.endY = evt.originalEvent.changedTouches[0].clientY
			reCalAnimation()
		,50,window
	$(window).on "touchend", (evt)->
		if ongoingMove.endX - ongoingMove.beginX > 100
			ongoingMove.beginX = 0
			ongoingMove.beginY = null
			ongoingMove.endX = 240
			ongoingMove.endY = null
		else
			ongoingMove.beginX = null
			ongoingMove.beginY = null
			ongoingMove.endX = null
			ongoingMove.endY = null
		reCalAnimation(true)


