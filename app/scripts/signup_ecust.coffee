$ ->
	firstClick = true
	window.callClick = ->
		if firstClick is true
			alert '讨厌!猴急!老娘一会再为你掀面纱!'
			firstClick = false
		else
			alert '还戳我!不是说了一会嘛!'
