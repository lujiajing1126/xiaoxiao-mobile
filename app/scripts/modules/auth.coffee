userSession = if localStorage.getItem("userSession") isnt null then localStorage.getItem "userSession" else $.cookie "userSession"
window.location.href = window.XXWEB.loginpage if userSession is null or window.XXWEB.uuidReg.test userSession isnt false

# Auth the status of session
window.auth = auth = ->
	Q $.ajax
		url: window.XXWEB.namespace + 'account/id?session=' + userSession,
		dataType: 'json',
	.then (data)->
		window.location.href = window.XXWEB.loginpage if data.status isnt "OK"
		try
			localStorage.setItem "userId",data.userId
		catch error
			$.cookie "userId",data.userId, path: '/'
