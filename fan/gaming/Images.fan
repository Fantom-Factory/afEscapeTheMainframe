using gfx::Image
using concurrent::Actor

@Js
class Images {
	private const Log log := typeof.pod.log

	private Str:Image images := Str:Image[:]
	
	
	
	Image[] preloadImages() {
		typeof.methods.findAll |method| {
			(method.returns == Image#) && (method.isPublic) && (!method.isStatic) && (method.params.size == 0)
		}.map |Method method->Image| {
			method.callOn(this, null)
		}
	}

	Void disposeAll() {
		images.each |image, imageName| {
			log.debug("Disposing Image $imageName")
			image.dispose
		}
	}

	protected Image load(Str imageName) {
		images.getOrAdd(imageName) |->Image| {
			log.debug("Loading Image $imageName")
			urlHook := (|Uri->Uri|?) Actor.locals["skySpark.urlHook"] ?: |Uri uri->Uri| { uri }
			return Image.make(urlHook(`fan://${typeof.pod}/res/images/${imageName}`))
		}
	}
}
