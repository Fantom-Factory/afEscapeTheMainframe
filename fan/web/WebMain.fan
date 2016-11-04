using afBedSheet
using afDuvet

class WebMain {
	
	static Void main(Str[] args) {
		BedSheetBuilder(WebModule#).addModulesFromPod("afDuvet").startWisp(8080, true)
	}
}
