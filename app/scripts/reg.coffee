$ ->
	countdownInterval = null
	notice = Notice.getInstance()
	$('#loginName').keyup (evt)->
		$sendCode = $('button#sendCode')
		console.log $('input#loginName').val()
		isEmail = window.XXWEB.emailReg.test($('input#loginName').val())
		isPhoneNumber = window.XXWEB.phoneReg.test($('input#loginName').val())
		if isPhoneNumber is true
			$sendCode.show()
		else
			$sendCode.hide()

	lockButton = (dom)->
		dom.addClass 'disabled'
	unlockButton = (dom)->
		dom.removeClass 'disabled'
	countdown = (dom)->
		dom.attr 'disabled',true
		second = 61
		countdownInterval = setInterval ->
			if second-- > 0
				dom.html "#{second}秒后重发验证码"
			else
				clearInterval countdownInterval
				$('button#sendCode').hide().html('发送验证码').removeAttr('disabled')
				$('#loginName').removeAttr('disabled')
		, 1000
	$(document).on 'touchstart','#goback',->
		window.location.href = '/login.html'
	$(document).on 'focus','#loginName',(evt)->
		$('#loginName').trigger 'keyup'
	$(document).on 'touchstart','button#sendCode', (evt)->
		evt.preventDefault()
		$this = $(this)
		phoneNumber = $('#loginName').val()
		if window.XXWEB.phoneReg.test(phoneNumber) is false
			notice.show text: '手机号错误，请检查'
			return
		$('#loginName').attr 'disabled',true
		$('#code-form-group').show()
		countdown $this
		$.ajax(url: '/api/session/create',type:'post',dataType:'json').then (data)->
			if data.status is 'OK'
				session = data.session
				$.ajax(url: '/api/account/send_verification_request_to_phone_number',type: 'post',dataType: 'json', data:{session:session,phone_number:phoneNumber}).then (data)->
					if data.status is 'OK'
						notice.show text:'验证码已发送'
					else if data.status is 'Error'
						notice.show text:data.message
						clearInterval countdownInterval
						$('button#sendCode').hide().html('发送验证码').removeAttr('disabled')
						$('#loginName').removeAttr 'disabled'
					else
						notice.show text:'未知错误'
	$(document).on 'touchstart','#area-reg',(evt)->
		evt.preventDefault()
		$this = $(this)
		if $this.hasClass 'disabled'
			return
		else
			lockButton $this
		dataForm = {}
		username = $('input#loginName').val()
		password = $('input#password').val()
		password_verification = $('input#password_verification').val()
		code = $('input#code').val()
		isPhoneNumber = window.XXWEB.phoneReg.test username
		isEmail = window.XXWEB.emailReg.test username
		if password isnt password_verification or password.length < 3 or password.length > 12 or code.length isnt 6
			notice.show text:'表单校验失败'
			unlockButton $this
			return
		dataForm['password'] = password
		if isPhoneNumber is true
			dataForm['phone_number'] = username
			dataForm['phone_number_verification_code'] = $('input#code').val()
		else if isEmail is true
			dataForm['email'] = username
		else
			notice.show text:'请输入邮箱地址或手机号'
			unlockButton $this
			return
		console.log dataForm
		$.ajax(url: '/api/session/create',type:'post',dataType:'json').then (data)->
			if data.status is 'OK'
				session = data.session
				$.ajax(url: '/api/account/register',type: 'post',dataType: 'json', data:$.extend(dataForm,session:session)).then (data)->
					if data.status is 'OK'
						notice.show text:'注册成功'
					else if data.status is 'Error'
						notice.show text:data.message
						unlockButton $this
					else
						notice.show text: '未知错误'
						unlockButton $this
			else
				notice.show text:'获取Session失败'
				unlockButton $this



