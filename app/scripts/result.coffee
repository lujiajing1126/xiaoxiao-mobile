$ ->
	phone_number = '13636586737'
	$('#userid').html "校校账号: #{phone_number}"
	$('#password').html "密码: #{phone_number.substring(5,11)}"