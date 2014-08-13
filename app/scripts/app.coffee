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
	userInfoFields: ['userInfo.gender',
            'userInfo.nickname',
            'userInfo.name',
            'studentInfo.studentId',
            'studentInfo.city',
            'studentInfo.school',
            'studentInfo.department',
            'studentInfo.grade',
            'studentInfo.district',
            'studentInfo.major',
            'studentInfo.classId',
            'extendedUserInfo.dayOfBirth',
            'extendedUserInfo.hobby',
            'extendedUserInfo.hometown',
            'extendedUserInfo.instanceMessageAccounts',
            'extendedUserInfo.isInRelation',
            'extendedUserInfo.location',
            'extendedUserInfo.monthOfBirth',
            'extendedUserInfo.sexualOrientation',
            'extendedUserInfo.yearOfBirth',
            'dynamic.numberOfFriends',
            'dynamic.numberOfFollowers',
            'dynamic.numberOfExecutingEvents',
            'dynamic.isfriend', 
            'dynamic.executingEvent'
        ]