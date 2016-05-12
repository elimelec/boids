import SpriteKit

class BirdNode: SKNode {
    let radius = 10.0
    let base = -50.0

    let maxSpeed: CGFloat = 4.0

	var shapeNode: SKShapeNode!
	var color: SKColor = SKColor.whiteColor()

	var shouldDie = false
    
    var velocity = CGPoint(x: 0.0, y: 0.0)

    var rules: [Rule]!

	var screenFrame: CGRect!
    
    init(frame: CGRect) {
		screenFrame = frame

        rules = [
            CohesionRule(weight: 1.0, frame: screenFrame),
            SeparationRule(weight: 0.8, frame: screenFrame),
            AlignmentRule(weight: 0.1, frame: screenFrame),
            NoiseRule(weight: 0.2, frame: screenFrame),
        ]

		color = randomColor()

		super.init()

        addShapeNode()
        //addFireNode()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addShapeNode() {
        let path = CGPathCreateMutable()
        let degrees = [0.0, 130.0, 260.0]
        for degree in degrees {
            let point = rotatedPoint(degree: degree, radius: radius, base: base)
            if degree == 0.0 {
                CGPathMoveToPoint(path, nil, point.x, point.y)
            } else {
                CGPathAddLineToPoint(path, nil, point.x, point.y)
            }
        }
        
        shapeNode = SKShapeNode(path: path)
        shapeNode.fillColor = color
        
        addChild(shapeNode)
    }
    
    func addFireNode() {
        guard let fireNode = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("fire", ofType: "sks")!) as? SKEmitterNode else { return }
        fireNode.particleScale = 0.1
        fireNode.xScale = 0.7
        fireNode.yScale = 0.9
        
        fireNode.particleLifetime = 0.3
        fireNode.emissionAngle = -CGFloat(degreeToRadian(90.0))
        fireNode.emissionAngleRange = 0.0
        fireNode.particlePositionRange = CGVector(dx: 0.0, dy: 0.1)

        fireNode.particleColor = SKColor.orangeColor()
        
        addChild(fireNode)
    }

	func prepareToDie() {
		color = SKColor.redColor()
		shouldDie = true
	}

    func update(birdNodes birdNodes: [BirdNode], frame: CGRect) {
        for rule in rules {
            rule.evaluate(targetNode: self, birdNodes: birdNodes)
        }
		updateColor(self, birdNodes:birdNodes)
        move(frame)
        rotate()
		if shouldDie {
			shapeNode.strokeColor = UIColor.redColor()
			shapeNode.fillColor = UIColor.redColor()
		}
		else {
			shapeNode.strokeColor = color
			shapeNode.fillColor = color
		}
    }

	func updateColor(boid: BirdNode, birdNodes:[BirdNode]) {
		var tRed: CGFloat = 0
		var tGreen: CGFloat = 0
		var tBlue: CGFloat = 0
		var tAlpha: CGFloat = 0

		boid.color.getRed(&tRed, green: &tGreen, blue: &tBlue, alpha: &tAlpha)

		var count: CGFloat = 1
		for boidNode in birdNodes {
			if boidNode == boid {
				continue
			}

			if distanceBetween(boidNode.position, boid.position) > 300 {
				continue
			}

			var red: CGFloat = 0
			var blue: CGFloat = 0
			var green: CGFloat = 0
			var alpha: CGFloat = 1

			boidNode.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

			tRed += red
			tGreen += green
			tBlue += blue
			tAlpha += alpha

			count += 1
		}

		tRed /= count
		tGreen /= count
		tBlue /= count
		tAlpha /= count

		boid.color = UIColor(red: tRed, green: tGreen, blue: tBlue, alpha: tAlpha)
	}

    private func move(frame: CGRect) {
        velocity.x += rules.reduce(0.0, combine: { sum, r in sum + r.weighted.x })
        velocity.y += rules.reduce(0.0, combine: { sum, r in sum + r.weighted.y })

        let vector = sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
        if (vector > maxSpeed) {
            velocity.x = (velocity.x / vector) * maxSpeed
            velocity.y = (velocity.y / vector) * maxSpeed
        }
        
        position.x += velocity.x
        position.y += velocity.y
        
        if (position.x - CGFloat(radius) <= 0) {
			position.x = CGRectGetWidth(frame) - CGFloat(radius)
			color = SKColor.yellowColor()
			delay(0.2) {
				self.color = randomColor()
			}
        }
        else if (position.x + CGFloat(radius) >= CGRectGetWidth(frame)) {
			position.x = CGFloat(radius)
			color = SKColor.yellowColor()
			delay(0.2) {
				self.color = randomColor()
			}
        }

        if (position.y - CGFloat(radius) <= 0) {
            position.y = CGRectGetHeight(frame) - CGFloat(radius)
			color = SKColor.yellowColor()
			delay(0.2) {
				self.color = randomColor()
			}
        }
        else if (position.y + CGFloat(radius) >= CGRectGetHeight(frame)) {
            position.y = CGFloat(radius)
			color = SKColor.yellowColor()
			delay(0.2) {
				self.color = randomColor()
			}
        }
    }
    
    private func rotate() {
        let radian = -atan2(Double(velocity.x), Double(velocity.y))
        zRotation = CGFloat(radian)
    }
}
