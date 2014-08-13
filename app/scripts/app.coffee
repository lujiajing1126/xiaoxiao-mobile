XXWEB = window.XXWEB = 
	namespace: '/api/',
	homepage: '/index.html',
	loginpage: '/login.html',
	regpage: '/reg.html',
	throttle: (method,delay,context)->
		clearTimeout method.tId
		method.tId = setTimeout ->
			method.call context
		,delay
	uuidReg: /^[a-z0-9]{8}(\-[a-z0-9]{4}){3}-[a-z0-9]{12}$/