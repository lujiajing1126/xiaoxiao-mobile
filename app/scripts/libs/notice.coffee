unique = null
class Notice
	expando: (""+Math.random()) .replace /\D/,""
	@getInstance: ->
		return unique if unique?
		unique = new Notice
	show: (obj)->
		$("body").append $("<div>").attr("class","notice").attr("id","notice-#{@expando}") if $("body > .notice").length is 0
		$("#notice-#{@expando}").html obj.text
		.css "opacity",1
		setTimeout =>
			$("#notice-#{@expando}").css "opacity",0
		,1000
this.Notice = Notice