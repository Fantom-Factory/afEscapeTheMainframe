
const class Point3d {
	
	const Float	x
	const Float	y
	const Float	z
	
	new make(Float x, Float y, Float z) {
		this.x	= x
		this.y	= y
		this.z	= z
	}
	
	new makeItBlock(|This| in) { in(this) }

	
	Point3d rotate(Float ax, Float ay, Float az) {
		// https://en.wikipedia.org/wiki/Rotation_matrix#In_three_dimensions
		y1 :=  ( y * Sin.cos( ay)) -( z * Sin.sin( ay))
		z1 :=  ( y * Sin.sin( ay)) +( z * Sin.cos( ay))

		x2 :=  ( x * Sin.cos(-az)) -(y1 * Sin.sin(-az))
		y2 :=  ( x * Sin.sin(-az)) +(y1 * Sin.cos(-az))

		x3 :=  (x2 * Sin.cos(-ax)) +(z1 * Sin.sin(-ax))
		z3 := -(x2 * Sin.sin(-ax)) +(z1 * Sin.cos(-ax))

		return Point3d(x3, y2, z3)
	}
	
	Point3d translate(Float dx, Float dy, Float dz) {
		Point3d(x + dx, y + dy, z + dz)
	}

//	Point3d scale(Float s) {
//		Point3d(x * s, y * s, z * s)
//	}

	Point2d applyPerspective(Float mul, Float add) {
		Point2d(x * mul / (z + add), y * mul / (z + add))
	}
}


const class Point2d {
	
	const Float	x
	const Float	y
	
	new make(Float x, Float y) {
		this.x	= x
		this.y	= y
	}
	
//	Point2d rotateBy(Float az) {
////		xx := (x * Sin.cos(angle)) - (y * Sin.sin(angle))
////		yy := (y * Sin.cos(angle)) + (x * Sin.sin(angle))
//		return Point2d(0f, 0f, 0f)
//	}
	
	Point2d translate(Float dx, Float dy) {
		Point2d(x + dx, y + dy)
	}

	Point2d scale(Float s) {
		Point2d(x * s, y * s)
	}
}
