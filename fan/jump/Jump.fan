using fwt
using gfx::Color
using gfx::Image
using afIoc

class Jump {

	@Inject Scope	scope
			Image	fanny
			Model	box
	
	new make(|This| in) {
		in(this)		
		
		box		= Models.cube
		fanny	= Image(`fan://afDemo/res/Fanny.png`)
	}
	
	Void draw(Gfx g) {
		g.brush = Color.white
		
//		g.drawImage(fanny, 50, 50)
		
		g3d := Gfx3d(g.offsetCentre)
		box.draw(g3d)
		
		box.ax += 1f/100f
		box.ay += 1f/280f
		box.az -= 1f/500f
	}
}


class Model {
	
	const Point3d[]	points
	const Int[][]	paths
	
	Float ax
	Float ay
	Float az
	
	new make(|This| in) { in(this) }
	
	Void draw(Gfx3d gfx) {
		gfx.drawModel(this)
	}
}

class Gfx3d {
	Gfx gfx

	static const Int perspective	:= 1000
	
	new make(Gfx gfx) {
		this.gfx = gfx
	}
	
	
	Void drawModel(Model model) {

		points := (Point2d[]) model.points.map {
			it.rotate(model.ax, model.ay, model.az).applyPerspective(300f, 300f).scale(0.5f)	//.translate(150f, 150f)
		}
		
		model.paths.each |path| {
			li := -1
			path.each |i| {
				p2 := points[i]
				
				if (li != -1) {
					p1 := points[li]
					gfx.drawLine(p1.x.toInt, -p1.y.toInt, p2.x.toInt, -p2.y.toInt)
				}
				
				li = i
			}
		}
	}
}

class Models {
	
	static Model cube() {
		Model {
			points = [
				Point3d(-100f,  100f, -100f),
				Point3d( 100f,  100f, -100f),
				Point3d( 100f, -100f, -100f),
				Point3d(-100f, -100f, -100f),
				Point3d(-100f,  100f,  100f),
				Point3d( 100f,  100f,  100f),
				Point3d( 100f, -100f,  100f),
				Point3d(-100f, -100f,  100f),
			]
			
			paths = [
				[0, 1, 2, 3, 0],
				[4, 5, 6, 7, 4],
				[0, 4],
				[1, 5],
				[2, 6],
				[3, 7],
			]
		}
	}
}