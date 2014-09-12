$ ->
	userSession = null
	userId = null
	notice = Notice.getInstance()
	searchStr = window.location.search
	searchParamsStr = searchStr.slice(1) if searchStr isnt ""
	searchParamsArr = searchParamsStr.split('&') if searchStr isnt "" and searchParamsStr isnt ""
	if searchParamsArr && searchParamsArr.length > 0
		searchParamsArr = searchParamsArr.map (v)->
			key = v.split('=')[0]
			value = v.split('=')[1]
			return {name:key,value:value}
	flag =  false
	flag = true if param is 'first' for param in searchParamsArr if searchParamsArr?
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
			$('ul.list-wrapper-list').html html
		.done ->
			setTimeout ->
				# 设置主层级的高度并显示
				$("div.mainLayout").css 'height',$(window).height()
				.show()
				$("#appLoadingIndicator").hide()
				$("html,body").css "background-color","transparent"
			,2000
	$(document).on 'click', '.apply', ->
		orgId = $(this).attr 'data-orgId'
		if !$(this).hasClass 'disabled'
			Q $.ajax 
				url: "/api/org/#{orgId}/jreq/send"
				data: 
					session: userSession
				dataType: 'json'
				type: 'post'
			.then (data)=>
				if data.status is 'OK'
					if flag is true
						window.location.href = './result.html'
					else
						$(this).html '待审核...'
						$(this).addClass 'disabled'
				else
					notice.show text:'申请失败'