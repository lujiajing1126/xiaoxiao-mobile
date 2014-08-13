$ ->
	windowHeight = $(window).height()
	ongoingTouches = {beginY:null,endY:null}
	$("body").height windowHeight
	$(".thirdLoginFooter").css 'top',windowHeight-100
	$(".functionFooter").css 'top',windowHeight-50
	reCalAnimation = ->
		begin = ongoingTouches.beginY || 0
		end = ongoingTouches.endY || 0
		# 防止拉太大
		if end-begin < 100
			$(".loginImg").css 'height',230+end-begin 
	$(document).on "touchstart",".loginImg",(evt)->
		evt.preventDefault()
		ongoingTouches.beginY = evt.originalEvent.changedTouches[0].clientY
	$(document).on "touchmove",".loginImg",(evt)->
		window.XXWEB.throttle ->
			console.log "move"
			ongoingTouches.endY = evt.originalEvent.changedTouches[0].clientY
			reCalAnimation()
		,50,window
	$(document).on "touchleave",".loginImg",(evt)->
		evt.preventDefault()
		ongoingTouches = {beginY:null,endY:null}
		reCalAnimation()
	$(document).on "touchend",".loginImg",(evt)->
		evt.preventDefault()
		ongoingTouches = {beginY:null,endY:null}
		reCalAnimation()
	$(document).on "focus","input#password",->
		$("body > .container").animate
			marginTop: "-40px"
		, 10
	$(document).on "blur","input#password",->
		$("body > .container").animate
			marginTop: "0px"
		, "slow"
	$(document).on 'touchstart','#area-login', (evt)->
		evt.preventDefault()
		$.ajax
			url: window.XXWEB.namespace + 'session/create'
			type: 'post'
			dataType: 'json'
		.done (data)->
			if data.status is "OK"
				_session = data.session
				$.ajax
					url: window.XXWEB.namespace + 'account/login',
					type: 'post',
					dataType: 'json',
					data:
						session: data.session,
						phone_number: $('#loginName').val(),
						password: $('#password').val()
				.done (data)->
					if data.status is "OK"
						localStorage.setItem "userSession",_session
						location.href = window.XXWEB.homepage
					else if data.status is "Error"
						$('#noticeContainer #msg').html data.message
						$('#noticeContainer').show()
	$(document).on 'click','#area-login', (evt) ->
		evt.preventDefault()
		alert "请到手机端使用"
