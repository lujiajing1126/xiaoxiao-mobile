$ ->
	firstClick = true
	window.callClick = ->
		if firstClick is true
			alert '讨厌,猴急,老娘9/15为你掀面纱'
			firstClick = false
		else
			alert '还戳我,不是说了9/15嘛'