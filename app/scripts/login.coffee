$ ->
	$(document).on 'touchstart','#btn-signin', (evt)->
		evt.preventDefault()
		$.ajax
			url: window.XXWEB.namespace + 'session/create'
			type: 'post'
			dataType: 'json'
		.done (data)->
			if data.status is "OK"
				$.ajax
					url: window.XXWEB.namespace + 'account/login',
					type: 'post',
					dataType: 'json',
					data:
						session: data.session,
						phone_number: $('#loginName').val(),
						password: $('#password').val()
				.done (data)->
					location.href = window.XXWEB.homepage if data.status is "OK"
	$(document).on 'click','#btn-signin', (evt) ->
		evt.preventDefault()
		alert "请到手机端使用"
