using afIoc
using afBedSheet
using afDuvet

class IndexPage {
    @Inject HtmlInjector? htmlInjector

    Text render() {
		htmlInjector.injectRequireScript(
			["sys":"sys"], "fan.sys.TimeZone.m_cur = fan.sys.TimeZone.fromStr('UTC');"
		)
		// inject Fantom code into the web page
        htmlInjector.injectFantomMethod(afFannyTheFantom::Main#main, ["Hello Mum!"], ["fwt.window.root":"fanny"])

        // let Duvet inject all it needs into a plain HTML shell
        return Text.fromHtml("<html><head></head><body><h1>Duvet by Alien-Factory</h1><div id='fanny' style='width: 768px; height:288px; position:relative;'></div></body></html>")
    }
}
