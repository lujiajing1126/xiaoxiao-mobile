;
(function() {
	var SESSION = window.SESSION;
	var expPhoneNumber = /(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)/,
		expStudentNumber = /\d+/,
		isXiaoxiao = true;

	var actions = {
		getAuthCode: function(event) {
			var phoneNumber = $("#phoneNumber").val();
			if (!SESSION) {
				alert("同学，请检查你的网络！");
				return;
			}
			if (expPhoneNumber.test($.trim(phoneNumber))) {
				$.ajax({
					url: window.XXWEB.namespace + 'account/send_verification_request_to_phone_number',
					type: 'post',
					dataType: 'json',
					data: {
						phone_number: phoneNumber,
						session: SESSION
					},
					success: function(data) {
						if (data.status == "OK") {
							$("#btn_auth_code").attr("disabled", "disabled").text("验证码已经在路上啦！！！");
						} else if (data.status == "Error") {
							if (data.message == "手机号已被占用") {
								alert("同学，你已经是校校的用户啦，请直接用您的手机号码登陆报名系统吧！");
								$("[name=isXiaoxiao][value=true]").trigger("click");
								return;
							} else {
								alert(data.message);
							}
						}
					},
					error: function(error) {
						log(error);
						errorHandler("同学，请检查你的网络！");
					}
				});
			} else {
				alert("同学，请检查你的手机号码！");
			}

			function errorHandler(error) {
				alert(error);
			}
		},
		signup: function(event) {
			event.preventDefault();
			if (isXiaoxiao) {
				loginThenSignup();
			} else {
				signupThenSignup();
			}
		}
	};
	createSession();
	$(document).on("keyup change", "#phoneNumber", function(event) {
		showAuthButton(this);
	});
	$(document).on("blur", "#phoneNumber", function(event) {
		showAuthButton(this);
	});
	$(document).on("touchend", "[data-xx-action]", function(event) {
		var actionName = $(this).attr("data-xx-action"),
			action = actions[actionName];
		action && $.isFunction(action) && action.call($(this), event);
	});
	$(document).on("keyup", function(event) {
		if (event.keyCode == 13) {
			event.preventDefault();
		}
	});

	$(document).on("change", "[name=isXiaoxiao]", function(event) {
		isXiaoxiao = $(this).val() == "true";
		if (isXiaoxiao) {
			$("#authCode,#userName").parents(".form-group").addClass("off");
			$("#btn_auth_code").addClass("off");
			$("#password").parents(".form-group").removeClass("off");
		} else {
			$("#authCode,#userName").parents(".form-group").removeClass("off");
			$("#btn_auth_code").removeClass("off");
			$("#password").parents(".form-group").addClass("off");
		}
	});

	// 根据用户输入判断是否显示验证码发送按钮
	var showAuthButton = function(obj) {
		var phone = $(obj).val();
		if (expPhoneNumber.test($.trim(phone))) {
			$("#btn_auth_code").removeAttr("disabled");
		}
	}

	function createSession() {
		$.ajax({
			url: window.XXWEB.namespace + 'session/create',
			type: 'post',
			dataType: 'json',
			success: function(data) {
				if (data && data.status == "OK") {
					SESSION = window.SESSION = data.session;
				}
			},
			error: function(error) {
				log(error);
				alert("请求失败，请检查您的网络！");
			}
		});
	}

	function formErrorTips(error, $input) {
		var tips = $input.attr("data-tips");
		$("#msg_tips").addClass("on").find(".alert").text(error);
		$input.parents(".form-group").addClass("has-error").attr("placeholder", tips).val("");
		setTimeout(function() {
			$("#msg_tips").removeClass("on");
			$input.parents(".form-group").removeClass("has-error");
		}, 3000);
	}


	function signupThenSignup() {
		var ipt_phoneNumber = $("#phoneNumber"),
			ipt_authCode = $("#authCode"),
			ipt_userName = $("#userName");
		var phoneNumber = ipt_phoneNumber.val(),
			authCode = ipt_authCode.val(),
			userName = ipt_userName.val();
		var msg;
		if (!expPhoneNumber.test($.trim(phoneNumber))) {
			formErrorTips("手机号码格式不对！", ipt_phoneNumber);
			return;
		}
		if (authCode.length != 6) {
			formErrorTips("验证码必须为6位数字！", ipt_authCode);
			return;
		}
		if (userName.length == 0) {
			formErrorTips("姓名不能为空！", ipt_userName);
			return;
		}
		signup(phoneNumber, userName, authCode, SESSION, function(data) {
			if (data.status != "OK") {
				alert(data.status + "：" + data.message);
				return;
			}
			var password = phoneNumber.slice(5, 11);
			login(phoneNumber, password, SESSION, function(data) {
				if (data.status != "OK") {
					alert(data.status + "：" + data.message);
					return;
				}
				var userId = data.userId;
				update(userId, userName, SESSION, function(data) {
					if (data.status != "OK") {
						alert(data.status + "：" + data.message);
						return;
					}
					baoming();
				}, function(error) {
					log(error);
					alert("请求失败，请检查您的网络！");
				});
			}, function(error) {
				log(error);
				alert("请求失败，请检查您的网络！");
			});
		}, function(error) {
			log(error);
			alert("请求失败，请检查您的网络！");
		});
	}

	function loginThenSignup() {
		var ipt_phoneNumber = $("#phoneNumber"),
			ipt_password = $("#password");
		var phoneNumber = ipt_phoneNumber.val(),
			password = ipt_password.val();
		var msg;
		if (!expPhoneNumber.test($.trim(phoneNumber))) {
			formErrorTips("手机号码格式不对！", ipt_phoneNumber);
			return;
		}
		if (password.length == 0) {
			formErrorTips("密码不能为空！", ipt_password);
			return;
		}
		login(phoneNumber, password, SESSION, function(data) {
			if (data.status != "OK") {
				alert(data.status + "：" + data.message);
				return;
			}
			baoming();
		}, function(error) {
			log(error);
			alert("请求失败，请检查您的网络！");
		});
	}

	//注册
	function signup(phoneNumber, userName, authCode, session, success, error) {
		$.ajax({
			url: window.XXWEB.namespace + 'account/register',
			type: 'post',
			dataType: 'json',
			data: {
				phone_number: phoneNumber,
				password: phoneNumber.slice(5, 11),
				phone_number_verification_code: authCode,
				session: session
			},
			success: success,
			error: error
		});
	}
	//注册成功之后登陆
	function login(phone_number, password, session, success, error) {
		$.ajax({
			url: window.XXWEB.namespace + 'account/login',
			type: 'post',
			dataType: 'json',
			data: {
				phone_number: phone_number,
				password: password,
				session: session
			},
			success: success,
			error: error
		});
	}

	//登陆之后修改个人信息
	function update(userId, userName, session, success, error) {
		var data = {
			userInfo: {
				name: userName
			}
		};
		$.ajax({
			url: window.XXWEB.namespace + 'user/' + userId + '/update',
			type: 'post',
			dataType: 'json',
			data: {
				session: session,
				data: JSON.stringify(data)
			},
			success: success,
			error: error
		});
	}

	function baoming() {
		var eventId = "";
		$.ajax({
			url: '/api/event/' + eventId + '/sign_up',
			type: 'post',
			dataType: 'json',
			data: {
				session: SESSION
			},
			success: function(data) {
				if (data.status != "OK") {
					alert(data.status + "：" + data.message);
					return;
				} else {
					alert("报名成功");
				}
			},
			error: function(error) {
				alert(error);
			}
		});
	}

	function log(message) {
		if (window.console && window.console.log)
			console.log(message);
	}
})();