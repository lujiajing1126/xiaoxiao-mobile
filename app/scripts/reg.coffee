$ ->
	$('#loginName').keydown (evt)->
		isEmail = window.XXWEB.emailReg.test($('#loginName').val())
		isPhoneNumber = window.XXWEB.phoneReg.test($('#loginName').val())
		if isEmail is true
			alert 'isemail'
		if isPhoneNumber is true
			alert 'isPhoneNumber'

	$(document).on 'click','#send_email', (evt)->
		alert '!'