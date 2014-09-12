$ ->
	windowHeight = $(window).height()
	ongoingTouches = {beginY:null,endY:null}
	notice = Notice.getInstance()
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
		username = $('#loginName').val()
		password = $('input[name=password]').val()
		console.log username
		console.log password
		if username.length is 0 or password.length > 12 or password.length < 3
			notice.show text:'请检查您的用户名或密码'
			return
		dataForm = 
			password: password
		isPhoneNumber = window.XXWEB.phoneReg.test username
		isEmail = window.XXWEB.emailReg.test username
		if isPhoneNumber is true
			dataForm['phone_number'] = username
		else if isEmail is true
			dataForm['email'] = username
		else
			notice.show text:'请输入邮箱地址或手机号'
			return
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
						$.extend(dataForm,session: data.session)
				.done (data)->
					if data.status is "OK"
						try
							localStorage.setItem "userSession",_session
						catch error
							$.cookie "userSession",_session, path: '/'
						finally
							location.href = window.XXWEB.homepage
					else if data.status is "Error"
						notice.show text:data.message
	$(document).on 'touchstart','.regButton',(evt)->
		evt.preventDefault()
		window.location.href = './reg.html'
