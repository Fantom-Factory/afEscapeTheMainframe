using afIoc
using afBedSheet
using web

class IndexPage {

	@Inject HttpRequest 	req
	
	new make(|This| f) { f(this) }

    Text render() {
		buf := StrBuf()
		FannyMod().onIndexPage(WebOutStream(buf.out), req.urlAbs)
        return Text.fromHtml(buf.toStr)
    }
}
