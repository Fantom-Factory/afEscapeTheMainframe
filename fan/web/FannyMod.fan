using gfx
using web
using webmod
using wisp

@NoDoc
const class FannyMod : WebMod {

	private const Str	windowTitle	:= FannyTheFantom.windowTitle
	private const Size	windowSize	:= FannyTheFantom.windowSize
	private const Str	windowDesc	:= "Fanny the Fantom :: A 3D vector jump game written in Fantom, created by Alien-Factory"
	private const Pod[] pods
	
	new make() {
		this.pods = "sys util concurrent gfx fwt web dom afBeanUtils afIoc afFannyTheFantom".split.map |podName| { Pod.find(podName) }
	}

	override Void onGet() {
		name := req.modRel.path.first
		if (name == null)
			onIndex
		else if (name == "pod")
			onPodFile
		else if (name == "favicon.ico")
			onFile(name)
		else
			res.sendErr(404)
	}

	Void onIndex() {
		res.headers["Content-Type"] = "text/html; charset=utf-8"
		onIndexPage(res.out, req.absUri)
	}

	Void onIndexPage(WebOutStream out, Uri reqAbsUri) {
	    env  := ["fwt.window.root" : "fwtRoot", "env" : Env.cur.vars["env"] ?: "prod"]

		out.docType5
		out.tag("html", "lang='en' prefix='og: http://ogp.me/ns#'").nl
		out.head
			out.title.w(windowTitle).titleEnd
			out.tag("meta", "charset='utf-8'").nl
			out.tag("meta", "http-equiv='X-UA-Compatible' content='IE=edge'").nl
			out.tag("meta", "name='description'        content=\"${windowDesc}\"").nl
			out.tag("meta", "property='og:type'        content='website'").nl
			out.tag("meta", "property='og:title'       content='${windowTitle}'").nl
			out.tag("meta", "property='og:url'         content='http://fanny.fantomfactory.org/'").nl
			out.tag("meta", "property='og:image'       content='http://fanny.fantomfactory.org/pod/afFannyTheFantom/doc/ogimage.png'").nl
			out.tag("meta", "property='og:description' content=\"${windowDesc}\"").nl
			out.tag("link", "href='/pod/afFannyTheFantom/res/web/fanny.css' type='text/css' rel='stylesheet'").nl
		
			pods.each |pod| { 
				out.includeJs(`/pod/${pod.name}/${pod.name}.js`)				
			}

			// see http://fantom.org/forum/topic/2548
			out.script.w("fan.sys.TimeZone.m_cur = fan.sys.TimeZone.fromStr('UTC');").scriptEnd
			WebUtil.jsMain(out, FannyTheFantom#.qname, env)
		out.headEnd		
		out.body

			out.div("class='bgScreen'")
				out.div("class='background'").divEnd
				out.div("class='logoFanny'").divEnd
				out.div("class='logoThe'").divEnd
				out.div("class='logoFantom'").divEnd
				out.div("class='bigFanny'").divEnd
				out.div("class='mask'").divEnd
				out.a(`http://www.alienfactory.co.uk/`, "class='alienLink'").img(`data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAKgAAAAQCAMAAAC1DMSeAAAA5FBMVEUAAAAg7iMVUxUg7iEe5SEbnhMUExMVuB8b7iMg3xsTExUTExcg7h4g6x4Tmx0c6yMfzhgUKhQUIBMXzCIUOBYe6yIZ2iIVrB4YbxMVsx8duxYYYBMWIBMa5iMX0iIg5h0dwRccsBUTixoTbBoTQxgexxcUTBYTIBUWQhMa6SMZ4SMWwB8fyxgYWRMXySAg6Bwf4hsThhsf2RoVZBgcuBcZixMUpB0VmBwg0xkVfxgdtBYZoRYcqBQb3yIWwiAWnh0g5RsZgxUWUBUWvCEZzSAYzR8TkBwf3xsTeBsblRMZth4ZdxMyvLh5AAAAAXRSTlMAQObYZgAAArtJREFUSMfVVVtb2kAQ3WloxCiEYIKCXJWbYpVbVUBU0Fbb/v//07MbBiZfRB74ePA86JJk55w5M7OrvhpuA6q01VZoHU+JcThXu0HrAtGv1Daol2gF60TtBsfGhh/bpJpDhCCxQL+tdoLWJWlUsexR15YJ3B+TQO2RUjNlcFCyfooQedg4zCoBv0SpRerNXwkKcdMjgYZSZ7mAgEQNewVVd1Z3qWLqcoo4c+5QospfWOorlabD4opsj/bzJFA4gp7vodAkYcFwLvHSVhIvy25KB8RIPZFAxrkmRqUNNoYubxpptU1LgZFZsHagofqB0Ow3AQ8fkfUQFzpIUtc7n3Lp33zlu5ruFO/OXUoNB2GApqP/3sFM/d+HC28TLM5eifbtPbqZhZ/dJammDe62vRxZE3YgjSdF9Y58/Q1CsxAKpbWF0PLSDlAXVFoOU4esgqstdcrcAgxOUidz7zGT9QdsdpOFDvUzCgJRKQdz8GAC0nhD6YdHlGmW9F5DNl0W6olA3eMSQ1kdIu0XbenBBXL4WOgZMlpVtQq2QZIjnOJZx0zOsvN/wxGd1wivizGh0WGCUFW/xG5bk3W41BkjVKIDjdqxjPlwjVBJhsgroVbfDKpux6usEoaOeVFDkqOI0OiEaKHKy2G/J/lBGVUDQxu2KegJHB2vcxTZRB0101VVjHOy/ikGjLzx2Npnz0VbbhCqWqY5PxPaMbVT/gUsLUPO2h7tZ6M9qm7NtLLQJPdG2JoF0ax5zN+Ehzw+TBDKStcLZUNDS+XUt4VQgMlGrwTJoS09l6iRjQt9D48rPk+f7WtxzsXPUQg1Sq/jQmOGsqXiHD20I0LlOdrk+ulp7XsxoXmyxqJdUyd8WQCN+M3EDeQ8kryZeoH4hUGHoRw+5YubqVKM3moLMitRgzKwmV1eGYaZ1dzFyfa18B9Iuz7W3SCF2QAAAABJRU5ErkJggg==`).aEnd
				out.a(`http://fantom-lang.org/`, "class='fantomLink' ").w("""<svg xmlns="http://www.w3.org/2000/svg" width="114" height="20"><linearGradient id="shield-b" x2="0" y2="100%"><stop offset="0" stop-color="#bbb" stop-opacity=".1"></stop><stop offset="1" stop-opacity=".1"></stop></linearGradient><mask id="shield-a"><rect width="114" height="20" rx="3" fill="#fff"></rect></mask><g mask="url(#shield-a)"><path fill="#555" d="M0 0h63v20H0z"></path><path fill="#9f9f9f" d="M63 0h51v20H63z"></path><path fill="url(#shield-b)" d="M0 0h114v20H0z"></path></g><g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11"><text x="31.5" y="15" fill="#010101" fill-opacity=".3">written in</text><text x="31.5" y="14">written in</text><text x="87.5" y="15" fill="#010101" fill-opacity=".3">Fantom</text><text x="87.5" y="14">Fantom</text></g></svg>""").aEnd
			out.divEnd
			out.div("class='gameScreen'")
				out.div("class='game'")
					out.div("id='fwtRoot' style='position:relative; width:${windowSize.w}px; height:${windowSize.h}px;'").divEnd
				out.divEnd
			out.divEnd

			// http://stackoverflow.com/questions/1495219/how-can-i-prevent-the-backspace-key-from-navigating-back
			// http://stackoverflow.com/a/26543616/1532548
			out.script.w("window.addEventListener('keydown', function (e) {
			              	var key;
			              	if (typeof e.keyIdentifier !== 'undefined')
			              		key = e.keyIdentifier;
			              
			              	if (typeof e.keyCode !== 'undefined')
			              		key = e.keyCode;
			              	
			              	if (key === 'U+0008' || key === 'Backspace' || key === 8)
			              		e.preventDefault();
			              }, true);")
			out.scriptEnd

			out.script.w("(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			              (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			              m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			              })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
			              ga('create', 'UA-33997125-11', 'auto');
			              ga('send', 'pageview');")
			out.scriptEnd

		out.bodyEnd
		out.htmlEnd
	}

	Void onPodFile() {
    	// serve up pod resources
    	File file := ("fan://" + req.uri[1..-1]).toUri.get
    	if (!file.exists) { res.sendErr(404); return }
    	FileWeblet(file).onService
   	}

	Void onFile(Str url) {
    	// serve up pod resources
    	File file := (`fan://afFannyTheFantom/res/web/${url}`).get
    	if (!file.exists) { res.sendErr(404); return }
    	FileWeblet(file).onService
   	}
}