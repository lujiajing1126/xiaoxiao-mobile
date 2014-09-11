$ ->
	userSession = null
	userId = null
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
		.then (data)->
			Q $.ajax
				url: "/api/assodir/#{window.AppUser.school}/load?session=#{userSession}"
				type: 'get'
				dataType: 'json'
		.then (data)->
			html = template 'orgList',{organizations: data.organizations}
			$('#eventCardBoard').html html
		.done ->
			setTimeout ->
				# 设置主层级的高度并显示
				$("div.mainLayout").css 'height',$(window).height()
				.show()
				$("#appLoadingIndicator").hide()
				$("html,body").css "background-color","transparent"
			,2000