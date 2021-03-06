$ ->
	ongoingMove = 
		beginX: null
		beginY: null
		endX: null
		endY: null
	userSession = null
	userId = null
	window.auth()
	.then ->
		# 获取数据
		try
			userSession = localStorage.getItem 'userSession'
			userId = localStorage.getItem 'userId'
		catch err
			userSession = $.cookie "userSession"
			userId = $.cookie "userId"
		finally
			if !userSession?
				userSession = $.cookie "userSession"
			if !userId?
				userId = $.cookie "userId"
		Q $.ajax
			url: "#{window.XXWEB.namespace}user/#{userId}/info?session=#{userSession}&fields=#{window.XXWEB.userInfoFields.join(',')}",
			type: 'get',
			dataType: 'json'
	.then (data)->
		window.AppUser = $.extend data.userInfo, data.dynamic
		$("span.userName").html data.userInfo.nickname
		$("div.userName > span").html data.userInfo.nickname
		$("a#school").html data.studentInfo.school
	.then ->
		Q $.ajax
			url: "#{window.XXWEB.namespace}account/list_events?session=#{userSession}&skip=0&limit=10"
			dataType: 'json'
	.then (data)->
		$("#eventCardBoard").html template "eventCard",{events:data.events} if data.status is "OK"
	, (err) ->
		console.log err
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
		try
			localStorage.setItem 'userSession',null
			localStorage.setItem 'userId',null
		catch err
			$.removeCookie "userSession"
			$.removeCookie "userId"
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
	$(document).on 'touchstart', '.mainLayout',(evt)->
		ongoingMove.beginX = evt.originalEvent.changedTouches[0].clientX
		ongoingMove.beginY = evt.originalEvent.changedTouches[0].clientY
	$(document).on "touchmove",'.mainLayout', (evt)->
		window.XXWEB.throttle ->
			ongoingMove.endX = evt.originalEvent.changedTouches[0].clientX
			ongoingMove.endY = evt.originalEvent.changedTouches[0].clientY
			reCalAnimation()
		,50,window
	$(document).on "touchend",'.mainLayout', (evt)->
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
	$(document).on 'touchstart','.viewPerson' ,(evt)->
		ongoingMove.beginX = 0
		ongoingMove.beginY = null
		ongoingMove.endX = 240
		ongoingMove.endY = null
	$(document).on 'touchstart','#generateQRcode',(evt)->
		try
			userSession = localStorage.getItem 'userSession'
		catch err
			userSession = $.cookie "userSession"
		finally
			if !userSession?
				userSession = $.cookie "userSession"
		$.ajax(url:'/api/account/get_qrcode_url',type:'post',dataType:'json',data:{session:userSession}).done (data)->
			if data.status is 'OK'
				$('img#qrcode').attr 'src',"http://qr.liantu.com/api.php?text=#{data.url}"
				$('#myModal').modal()