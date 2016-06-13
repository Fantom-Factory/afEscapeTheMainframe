using fwt
using gfx::Color
using gfx::Image
using gfx::Brush
using afIoc

class Jump {

	@Inject Scope	scope
			Image	fanny
			Model	cube
			Model	grid
	
	new make(|This| in) {
		in(this)		
		
		cube	= Models.cube
		grid	= Models.grid {
			it.rotate(0f, 0.25f, 0f)
			it.translate(0f, -100f, -100f)
			it.colour = Color(0xFF_33_66_FF)
		}
		fanny	= Image(`fan://afDemo/res/Fanny.png`)
	}

	Void draw(Gfx g) {
//		g.drawImage(fanny, 50, 50)
		
//		g.clear(Color(0xFF_00_00_33))
//		g.clear(Color(0xFF_00_00_33))
		g.clear(Color(0xFF_00_00_33))
		
		g3d := Gfx3d(g.offsetCentre)
		grid.dup.translate(-x.toFloat, 0f, 0f).scale(5f, 1.1f, 1.1f).draw(g3d)
		cube.draw(g3d)
		
		cube.ax += 1f/100f
		cube.ay += 1f/280f
		cube.az -= 1f/500f
		
		x += 1
		if (x > 20)
			x -= 20
	}
	
	Int x
}


class Model {
		Point3d[]	points
	const Int[][]	paths
	
	Float	ax
	Float	ay
	Float	az
	Color	colour	:= Color.white
	
	new make(|This| in) { in(this) }
	
	This rotate(Float ax, Float ay, Float az) {
		points = points.map { it.rotate(ax, ay, az) }
		return this
	}
	
	This scale(Float sx, Float sy := sx, Float sz := sx) {
		points = points.map { it.scale(sx, sy, sz) }
		return this
	}
	
	This translate(Float dx, Float dy, Float dz) {
		points = points.map { it.translate(dx, dy, dz) }
		return this
	}
	
	Model dup() {
		Model {
			it.points	= this.points.dup
			it.paths	= this.paths
			it.colour	= this.colour
			it.ax		= this.ax
			it.ay		= this.ay
			it.az		= this.az
		}
	}
	
	Void draw(Gfx3d gfx) {
		gfx.brush = colour
		gfx.drawModel(this)
	}
}

class Gfx3d {
	Gfx gfx

	static const Int perspective	:= 1000
	
	new make(Gfx gfx) {
		this.gfx = gfx
	}
	
	Brush brush {
		get { gfx.brush }
		set { gfx.brush = it }
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

	static Model grid() {
		Model {
			points = [
				Point3d(-100f,  50f, 0f),
				Point3d(- 80f,  50f, 0f),
				Point3d(- 60f,  50f, 0f),
				Point3d(- 40f,  50f, 0f),
				Point3d(- 20f,  50f, 0f),
				Point3d(   0f,  50f, 0f),
				Point3d(  20f,  50f, 0f),
				Point3d(  40f,  50f, 0f),
				Point3d(  60f,  50f, 0f),
				Point3d(  80f,  50f, 0f),
				Point3d( 100f,  50f, 0f),

				Point3d(-100f, -50f, 0f),
				Point3d(- 80f, -50f, 0f),
				Point3d(- 60f, -50f, 0f),
				Point3d(- 40f, -50f, 0f),
				Point3d(- 20f, -50f, 0f),
				Point3d(   0f, -50f, 0f),
				Point3d(  20f, -50f, 0f),
				Point3d(  40f, -50f, 0f),
				Point3d(  60f, -50f, 0f),
				Point3d(  80f, -50f, 0f),
				Point3d( 100f, -50f, 0f),

				Point3d(-100f,  30f, 0f),
				Point3d(-100f,  10f, 0f),
				Point3d(-100f, -10f, 0f),
				Point3d(-100f, -30f, 0f),
				Point3d(-100f, -50f, 0f),

				Point3d( 100f,  30f, 0f),
				Point3d( 100f,  10f, 0f),
				Point3d( 100f, -10f, 0f),
				Point3d( 100f, -30f, 0f),
				Point3d( 100f, -50f, 0f),
			]
			
			paths = [
				[ 0, 11],
				[ 1, 12],
				[ 2, 13],
				[ 3, 14],
				[ 4, 15],
				[ 5, 16],
				[ 6, 17],
				[ 7, 18],
				[ 8, 19],
				[ 9, 20],
				[10, 21],
				
				[ 0, 10],
				[11, 21],
				
				[22, 27],
				[23, 28],
				[24, 29],
				[25, 30],
				[26, 31],
			]
		}
	}
}