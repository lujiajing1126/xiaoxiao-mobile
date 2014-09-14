$ ->
	userSession = null
	userId = null
	phone_number = null
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
			window.AppUser = $.extend data.userInfo, data.dynamic, data.studentInfo
			$("span.userName").html data.userInfo.nickname
			$("div.userName > span").html data.userInfo.nickname
			$("a#school").html data.studentInfo.school
			phone_number = data.loginMethod.phoneNumbers[0]
		.done ->
			$('#userid').html "校校账号: #{phone_number}"
			$('#password').html "初始密码: #{phone_number.substring(5,11)}(手机号后6位)"