
** A runnable with error handling. The default impl simply logs the error and returns 'null'. 
** Useful for FWT callbacks which have a habit of silently failing.
class Safe {
	private static const Log log := Log.get("Safe")
	
	private |->Obj?|? f
	
	new make(|->Obj?|? f) {
		this.f = f
	}
	
	// TODO: add alternative error handling
	Obj? run() {
		try {
			return f?.call
		} catch (Err e) {
			log.err(e.msg, e)
			return null
		}
	}
}
