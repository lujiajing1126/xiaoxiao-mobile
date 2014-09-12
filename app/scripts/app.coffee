XXWEB = window.XXWEB = 
	namespace: '/api/'
	homepage: './index.html'
	loginpage: './login.html'
	regpage: './reg.html'
XXWEB.emailReg = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
XXWEB.phoneReg = /(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)/

XXWEB.uuidReg = /^[a-z0-9]{8}(\-[a-z0-9]{4}){3}-[a-z0-9]{12}$/
XXWEB.throttle = (method,delay,context)->
      clearTimeout method.tId
      method.tId = setTimeout ->
            method.call context
      , delay

XXWEB.userInfoFields = ["userInfo.gender","userInfo.nickname","userInfo.name","studentInfo.studentId","studentInfo.city","studentInfo.school","studentInfo.department","studentInfo.grade","studentInfo.district","studentInfo.major","studentInfo.classId","extendedUserInfo.dayOfBirth","extendedUserInfo.hobby","extendedUserInfo.hometown","extendedUserInfo.instanceMessageAccounts","extendedUserInfo.isInRelation","extendedUserInfo.location","extendedUserInfo.monthOfBirth","extendedUserInfo.sexualOrientation","extendedUserInfo.yearOfBirth","dynamic.numberOfFriends","dynamic.numberOfFollowers","dynamic.numberOfExecutingEvents","dynamic.isfriend", "dynamic.executingEvent","loginMethod.phoneNumbers"]