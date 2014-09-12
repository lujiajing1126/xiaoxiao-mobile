;
(function() {
	var SESSION = window.SESSION;
	var expPhoneNumber = /(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)/,
		expStudentNumber = /\d+/;
	var actions = {
		getAuthCode: function(event) {
			var phoneNumber = $("#phoneNumber").val();
			if (!SESSION) {

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
							errorHandler(data.message);
						}
					},
					error: function(error) {
						errorHandler(error);
					}
				});
			}

			function errorHandler(error) {
				alert(error);
			}
		},
		signup: function(event) {
			event.preventDefault();
			if (validateForm()) {
				
			}
		}
	};
	createSession();
	$(document).on("keyup", "#phoneNumber", function(event) {
		showAuthButton(this);
	});
	$(document).on("click", "[data-xx-action]", function(event) {
		var actionName = $(this).attr("data-xx-action"),
			action = actions[actionName];
		action && $.isFunction(action) && action.call($(this), event);
	});

	// 根据用户输入判断是否显示验证码发送按钮
	var showAuthButton = function(obj) {
		var phone = $(obj).val();
		if (expPhoneNumber.test($.trim(phone))) {
			$("#btn_auth_code").removeClass("off").addClass("on");
		} else
			$("#btn_auth_code").addClass("off").removeClass("on");
	}

	function createSession() {
		$.ajax({
			url: window.XXWEB.namespace + 'session/create',
			type: 'post',
			dataType: 'json',
			success: function(data) {
				console.log(data);
				if (data && data.status == "OK") {
					SESSION = window.SESSION = data.session;
				}
			},
			error: function(error) {
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
		if (expPhoneNumber.test($.trim(phoneNumber))) {
			formErrorTips("手机号码格式不对！", ipt_phoneNumber);
			resault = false;
		} else if (authCode.length != 6) {
			formErrorTips("验证码必须为6位数字！", ipt_authCode);
			resault = false;
		} else if (userName.length == 0) {
			formErrorTips("用户名不能为空！", ipt_userName);
			resault = false;
		} else if (studentNumber.length == 0) {
			formErrorTips("学号不能为空！", ipt_studentNumber);
			resault = false;
		} else if (expStudentNumber.test(studentNumber)) {
			formErrorTips("学号只能为数字！", ipt_studentNumber);
			resault = false;
		}
		return resault;
	}

	function formErrorTips(error, $input) {
		var tips = $input.attr("data-tips");
		$("#msg_tips").addClass("on").find(".alert").text(error);
		$input.parent(".form-group").addClass("has-error").attr("placeholder", tips).val("");
		setTimeout(function() {
			$("#msg_tips").removeClass("on");
			$input.parent(".form-group").removeClass("has-error");
		}, 3000);
	}

	function signup() {
		$.ajax({
			url: window.XXWEB.namespace + 'account/send_verification_request_to_phone_number'
		});
	}
})();