import SpriteKit

class BirdNode: SKNode {
    let radius = 10.0
    let base = -50.0

    let maxSpeed: CGFloat = 4.0
    
    var velocity = CGPoint(x: 0.0, y: 0.0)

    var rules: [Rule]!
    
    override init() {

        super.init()

        rules = [
            CohesionRule(weight: 1.0),
            SeparationRule(weight: 0.8),
            AlignmentRule(weight: 0.1),
            NoiseRule(weight: 0.2)
        ]

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
        
        let shapeNode = SKShapeNode(path: path)
        shapeNode.fillColor = SKColor.whiteColor()
        
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

    func update(birdNodes birdNodes: [BirdNode], frame: CGRect) {
        for rule in rules {
            rule.evaluate(targetNode: self, birdNodes: birdNodes)
        }
        move(frame)
        rotate()
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
            position.x = CGFloat(radius)
            velocity.x *= -1
        }
        if (position.x + CGFloat(radius) >= CGRectGetWidth(frame)) {
            position.x = CGRectGetWidth(frame) - CGFloat(radius)
            velocity.x *= -1
        }

        if (position.y - CGFloat(radius) <= 0) {
            position.y = CGFloat(radius)
            velocity.y *= -1
        }
        if (position.y + CGFloat(radius) >= CGRectGetHeight(frame)) {
            position.y = CGRectGetHeight(frame) - CGFloat(radius)
            velocity.y *= -1
        }
    }
    
    private func rotate() {
        let radian = -atan2(Double(velocity.x), Double(velocity.y))
        zRotation = CGFloat(radian)
    }
}
