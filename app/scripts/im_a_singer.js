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
			var target = $(this);
			if (isXiaoxiao) {
				loginThenSignup(target);
			} else {
				signupThenSignup(target);
			}
		}
	};
	createSession();
	init();

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
		formController(isXiaoxiao);
	});


	function init() {
		isXiaoxiao = $("[name=isXiaoxiao][checked]").val() == "true";
		formController(isXiaoxiao);
	}

	function formController(xiaoxiao) {
		if (xiaoxiao) {
			$("#authCode,#userName,#studentNumber").parents(".form-group").addClass("off");
			$("#btn_auth_code").addClass("off");
			$("#password").parents(".form-group").removeClass("off");
			$("#tips_wrapper").removeClass("off");
		} else {
			$("#authCode,#userName,#studentNumber").parents(".form-group").removeClass("off");
			$("#btn_auth_code").removeClass("off");
			$("#password").parents(".form-group").addClass("off");
			$("#tips_wrapper").addClass("off");
		}
	}

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


	function signupThenSignup(target) {
		var ipt_phoneNumber = $("#phoneNumber"),
			ipt_authCode = $("#authCode"),
			ipt_userName = $("#userName"),
			ipt_studentNumber = $("#studentNumber");
		var phoneNumber = ipt_phoneNumber.val(),
			authCode = ipt_authCode.val(),
			userName = ipt_userName.val(),
			studentNumber = ipt_studentNumber.val();
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
		if (!expStudentNumber.test(studentNumber)) {
			formErrorTips("请填写正确的学号！", ipt_studentNumber);
			return;
		}
		signup(phoneNumber, userName, studentNumber, authCode, SESSION, function(data) {
			if (data.status != "OK") {
				if (data.status == "Error" && data.message == "登录名已被占用") {
					alert("同学，你已经是校校用户了，可以直接报名哦！");
					$("[name=isXiaoxiao][value=true]").trigger("click");
					target.removeAttr("disabled").text("我要报名");
					return;
				}
				alert(data.status + "：" + data.message);
				target.removeAttr("disabled").text(data.status + "：" + data.message);
				return;
			}
			var password = phoneNumber.slice(5, 11);
			login(phoneNumber, password, SESSION, function(data) {
				if (data.status != "OK") {
					alert(data.status + "：" + data.message);
					target.removeAttr("disabled").text(data.status + "：" + data.message);
					return;
				}
				var userId = data.userId;
				try {
					localStorage.setItem("userSession", SESSION);
				} catch (err) {
					$.cookie("userSession", SESSION, {
						path: "/"
					});
				}
				update(userId, userName, studentNumber, SESSION, function(data) {
					if (data.status != "OK") {
						alert(data.status + "：" + data.message);
						target.removeAttr("disabled").text(data.status + "：" + data.message);
						return;
					}
					baoming(target);
				}, function(error) {
					log(error);
					target.removeAttr("disabled").text(error);
					alert("请求失败，请检查您的网络！");
				});
			}, function(error) {
				log(error);
				target.removeAttr("disabled").text(error);
				alert("请求失败，请检查您的网络！");
			});
		}, function(error) {
			log(error);
			target.removeAttr("disabled").text(error);
			alert("请求失败，请检查您的网络！");
		});
	}

	function loginThenSignup(target) {
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
		target.attr("disabled", "disabled").text("正在报名...");
		login(phoneNumber, password, SESSION, function(data) {
			if (data.status != "OK") {
				alert(data.status + "：" + data.message);
				target.removeAttr("disabled").text(data.status + "：" + data.message);
				return;
			}
			baoming(target);
		}, function(error) {
			log(error);
			target.removeAttr("disabled").text(error);
			alert("请求失败，请检查您的网络！");
		});
	}

	//注册
	function signup(phoneNumber, userName, studentNumber, authCode, session, success, error) {
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
	function update(userId, userName, studentNumber, session, success, error) {
		var data = {
			userInfo: {
				name: userName,
				nickName: userName
			},
			studentInfo: {
				school: "上海大学",
				studentId: studentNumber
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

	function baoming(target) {
		var eventId = "54090a84e4b07212ac847349";
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
					target.removeAttr("disabled").text(data.status + "：" + data.message);
					return;
				} else {
					alert("报名成功");
					target.attr("disabled", "disabled").text("报名成功！");
					if (!isXiaoxiao) {
						window.location.href = "./result.html";
					}
				}
			},
			error: function(error) {
				target.removeAttr("disabled").text(error);
				alert(error);
			}
		});
	}

	function log(message) {
		if (window.console && window.console.log)
			console.log(message);
	}
})();