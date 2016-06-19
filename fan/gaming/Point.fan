
const class Point2d {
	
	const Float	x
	const Float	y

	static const Point2d defVal := Point2d(0f, 0f)

	new make(Float x, Float y) {
		this.x	= x
		this.y	= y
	}
	
	Point2d rotate(Float a) {
		xx := (x * Sin.cos(a)) - (y * Sin.sin(a))
		yy := (y * Sin.cos(a)) + (x * Sin.sin(a))
		return Point2d(xx, yy)
	}

	Point2d translate(Float dx, Float dy) {
		Point2d(x + dx, y + dy)
	}

	Point2d scale(Float s) {
		Point2d(x * s, y * s)
	}
	override Str toStr() {
		"(" + x.toLocale("0.00") + "," + y.toLocale("0.00") + ")"
	}
}

const class Point3d {
	
	const Float	x
	const Float	y
	const Float	z
	
	static const Point3d defVal := Point3d(0f, 0f, 0f)
	
	new make(Float x, Float y, Float z) {
		this.x	= x
		this.y	= y
		this.z	= z
	}
	
	new makeItBlock(|This| in) { in(this) }

	Point3d rotate(Float ax, Float ay, Float az) {
		// https://en.wikipedia.org/wiki/Rotation_matrix#In_three_dimensions
		y2 :=  ( y * Sin.cos(-ax)) -( z * Sin.sin(-ax))
		z2 :=  ( y * Sin.sin(-ax)) +( z * Sin.cos(-ax))

		x2 :=  ( x * Sin.cos(-ay)) +(z2 * Sin.sin(-ay))
		z3 := -( x * Sin.sin(-ay)) +(z2 * Sin.cos(-ay))

		x3 :=  (x2 * Sin.cos(-az)) -(y2 * Sin.sin(-az))
		y3 :=  (x2 * Sin.sin(-az)) +(y2 * Sin.cos(-az))

		return Point3d(x3, y3, z3)
	}

	Point3d translate(Float dx, Float dy, Float dz) {
		Point3d(x + dx, y + dy, z + dz)
	}

	Point3d scale(Float sx, Float sy := sx, Float sz := sx) {
		Point3d(x * sx, y * sy, z * sz)
	}

	Point3d project(Float mul) {
		Point3d(x * mul / z, y * mul / z, z)
	}

	** Return the magnitude of the vector.
	Float scalar() {
		(x.pow(3f) + y.pow(3f) + z.pow(3f)).pow(1f/3f)
	}

	** Returns the unit vector. A unit vector has the same direction, but a magnitude of 1.
	Point3d normalise() {
		s := scalar
		return Point3d(x / s, y / s, z / s)
	}
	
	** Returns the absolute value of this vector.
	Point3d abs() {
		Point3d(x.abs, y.abs, z.abs)
	}
	
	static Point3d crossProduct(Point3d p1, Point3d p2) {
		cx	:= (p1.y * p2.z) - (p1.z * p2.y)
		cy	:= (p1.z * p2.x) - (p1.x * p2.z)
		cz	:= (p1.x * p2.y) - (p1.y * p2.x)
		return Point3d(cx, cy, cz)
	}
	Point3d cross(Point3d p2) {
		cx	:= (y * p2.z) - (z * p2.y)
		cy	:= (z * p2.x) - (x * p2.z)
		cz	:= (x * p2.y) - (y * p2.x)
		return Point3d(cx, cy, cz)
	}
	
	static Float dotProduct(Point3d p1, Point3d p2) {
		dx := p1.x * p2.x
		dy := p1.y * p2.y
		dz := p1.z * p2.z
		return dx + dy + dz
	}

	** Points must go *clockwise* to be visible.
	static Point3d normal(Point3d p1, Point3d p2, Point3d p3) {
		nx := ((p2.y - p1.y)*(p3.z - p1.z)) - ((p2.z - p1.z)*(p3.y - p1.y))
		ny := ((p2.z - p1.z)*(p3.x - p1.x)) - ((p2.x - p1.x)*(p3.z - p1.z))
		nz := ((p2.x - p1.x)*(p3.y - p1.y)) - ((p2.y - p1.y)*(p3.x - p1.x))
		return Point3d(nx, ny, nz)
	}

	override Str toStr() {
//		"(" + x.toLocale("0.00") + "," + y.toLocale("0.00") + "," + z.toLocale("0.00") + ")"
		"(" + x.toLocale("0") + "," + y.toLocale("0") + "," + z.toLocale("0") + ")"
	}
}
