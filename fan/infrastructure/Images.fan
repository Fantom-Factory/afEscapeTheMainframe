using gfx

@Js
class Images {
	private const Log log := typeof.pod.log

	private [Str:Image] images := [:]
	
	
	
	Image[] preloadImages() {
		typeof.methods.findAll |method| {
			(method.returns == Image#) && (method.isPublic) && (!method.isStatic) && (method.params.size == 0)
		}.map |Method method->Image?| {
			method.callOn(this, null)
		}
	}

	Void disposeAll() {
		images.each |image, imageName| {
			log.info("Disposing Image $imageName")
			image.dispose
		}
	}

	protected Image load(Str imageName) {
		images.getOrAdd(imageName) |->Image| {
			log.info("Loading Image $imageName")
			return Image.make(`fan://${typeof.pod}/res/images/${imageName}`)
		}
	}
}
