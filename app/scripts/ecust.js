;
(function() {
	var SESSION = window.SESSION;
	var expPhoneNumber = /(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)/,
		expStudentNumber = /\d+/;

	var Schools = ["华东理工大学", "华东师范大学", "上海外国语大学"],
		school = Schools[school_index];

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
							var btn_auth_code = $("#btn_auth_code"),
								delay = 60;
							btn_auth_code.attr("disabled", "disabled").text("发送成功，60秒后重试！");
							var timer = function() {
								btn_auth_code.text("发送成功，" + (--delay) + "秒后重试！");
								if(delay==0){
									btn_auth_code.removeAttr("disabled").text("重新发送！");
									return;
								} 
								setTimeout(function() {
									timer();
								}, 1000);
							};
							timer();
						} else if (data.status == "Error") {
							if (data.message == "手机号已被占用") {
								alert("同学，你之前已经填写过个人信息了，请直接用您的手机号码登陆报名系统吧，如果你没有进行密码修改操作，你的密码可能会是你的手机号后6位哦！");
								window.location.href = "./login.html?continue=result.html";
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
			if (validateForm()) {
				var ipt_phoneNumber = $("#phoneNumber"),
					ipt_authCode = $("#authCode"),
					ipt_userName = $("#userName"),
					ipt_studentNumber = $("#studentNumber");

				var phoneNumber = ipt_phoneNumber.val(),
					authCode = ipt_authCode.val(),
					userName = ipt_userName.val(),
					studentNumber = ipt_studentNumber.val(),
					grade = $("#grade").val();
				var password = phoneNumber.slice(5, 11),
					district;

				if (school == "华东师范大学") {
					district = $("#schoolArea").val();
				}

				var data = {
					phone_number: phoneNumber,
					phone_number_verification_code: authCode,
					password: password,
					userName: userName,
					studentNumber: studentNumber,
					school: school,
					grade: grade
				};
				if (district) {
					data.district = district;
				}

				signup(data, SESSION);
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

	// 根据用户输入判断是否显示验证码发送按钮
	var showAuthButton = function(obj) {
		var phone = $(obj).val();
		if (expPhoneNumber.test($.trim(phone))) {
			$("#btn_auth_code").removeAttr("disabled");
		} else {
			//$("#btn_auth_code").attr("disabled","disabled");
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

	function validateForm() {
		var ipt_phoneNumber = $("#phoneNumber"),
			ipt_authCode = $("#authCode"),
			ipt_userName = $("#userName"),
			ipt_studentNumber = $("#studentNumber");
		var phoneNumber = ipt_phoneNumber.val(),
			authCode = ipt_authCode.val(),
			userName = ipt_userName.val(),
			studentNumber = ipt_studentNumber.val();

		var resault = true;
		if (!expPhoneNumber.test($.trim(phoneNumber))) {
			formErrorTips("手机号码格式不对！", ipt_phoneNumber);
			resault = false;
		} else if (authCode.length != 6) {
			formErrorTips("验证码必须为6位数字！", ipt_authCode);
			resault = false;
		} else if (userName.length == 0) {
			formErrorTips("姓名不能为空！", ipt_userName);
			resault = false;
		} else if (studentNumber.length == 0) {
			formErrorTips("学号不能为空！", ipt_studentNumber);
			resault = false;
		} else if (!expStudentNumber.test(studentNumber)) {
			formErrorTips("学号只能为数字！", ipt_studentNumber);
			resault = false;
		}
		return resault;
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



	//注册
	function signup(vdata, session) {
		$.ajax({
			url: window.XXWEB.namespace + 'account/register',
			type: 'post',
			dataType: 'json',
			data: {
				phone_number: vdata.phone_number,
				password: vdata.password,
				phone_number_verification_code: vdata.phone_number_verification_code,
				session: session
			},
			success: function(data) {
				if (data.status == "OK") {
					login(vdata, session);
				} else if (data.status == "Error") {
					if (data.message == "登录名已被占用") {
						alert("同学，你之前已经填写过个人信息了，请直接用您的手机号码登陆报名系统吧，如果你没有进行密码修改操作，你的密码可能会是你的手机号后6位哦！");
						window.location.href = "./login.html?continue=result.html";
					} else {
						alert(data.message);
					}
				} else {
					alert("请求失败，请检查您的网络！");
				}
			},
			error: function(error) {
				log(error);
				alert("请求失败，请检查您的网络！");
			}
		});
	}
	//注册成功之后登陆
	function login(vdata, session) {
		$.ajax({
			url: window.XXWEB.namespace + 'account/login',
			type: 'post',
			dataType: 'json',
			data: {
				phone_number: vdata.phone_number,
				password: vdata.password,
				session: session
			},
			success: function(data) {
				if (data.status == "OK") {
					var userId = data.userId,
						userData = {
							userInfo: {
								name: vdata.userName,
								nickName: vdata.userName
							},
							studentInfo: {
								grade: +vdata.grade,
								school: vdata.school,
								studentId: vdata.studentNumber
							}
						};
					if (vdata.district) {
						userData.studentInfo.district = vdata.district;
					}
					update(userId, userData, session);
					try {
						localStorage.setItem("userSession", session);
					} catch (err) {
						$.cookie("userSession", session, {
							path: "/"
						});
					}
				} else {
					alert("请求失败，请检查您的网络！");
				}
			},
			error: function(error) {
				log(error);
				alert("请求失败，请检查您的网络！");
			}
		});
	}
	//登陆之后修改个人信息
	function update(userId, data, session) {
		console.log(JSON.stringify(data));
		$.ajax({
			url: window.XXWEB.namespace + 'user/' + userId + '/update',
			type: 'post',
			dataType: 'json',
			data: {
				session: session,
				data: JSON.stringify(data)
			},
			success: function(data) {
				if (data.status == "OK") {
					alert("信息提交成功，快去申请加入你感兴趣的组织吧。");
					window.location.href = "./apply.html?first=true";
				}
			},
			error: function(error) {
				log(error);
				alert("请求失败，请检查您的网络！");
			}
		});
	}

	function log(message) {
		if (window.console && window.console.log)
			console.log(message);
	}
})();