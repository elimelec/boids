import UIKit

func degreeToRadian(degree: Double) -> Double {
	return degree * M_PI / 180.0
}

func distanceBetween(pointA: CGPoint, _ pointB: CGPoint) -> Double {
	let x = Double(pointA.x - pointB.x)
	let y = Double(pointA.y - pointB.y)
	return sqrt(x * x  + y * y)
}

func rotatedPoint(degree degree: Double, radius: Double, base: Double = 0.0) -> CGPoint {
	let radian = degreeToRadian(degree + base)
	let x = radius * cos(radian)
	let y = radius * sin(radian)
	return CGPoint(x: x, y: y)
}
