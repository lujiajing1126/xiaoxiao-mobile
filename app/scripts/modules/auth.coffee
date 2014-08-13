userSession = localStorage.getItem "userSession"
window.location.href = window.XXWEB.homepage if userSession is null or window.XXWEB.uuidReg.test userSession isnt false

# Auth the status of session
$.ajax
	url: window.XXWEB.namespace + 'account/id?session=' + userSession,
	dataType: 'json',
.done (data)->
	window.location.href = window.XXWEB.loginpage if data.status isnt "OK"
	localStorage.setItem "userId",data.userId
