import UIKit

class Rule: NSObject {
    var velocity: CGPoint!
    var weight: CGFloat
	var frame: CGRect

    var weighted: CGPoint {
        return CGPoint(x: velocity.x * weight, y: velocity.y * weight)
    }

    init(weight: CGFloat, frame: CGRect) {
        self.weight = weight
		self.frame = frame
        super.init()
        clear()
    }
    
    func clear() {
        velocity = CGPoint(x: 0.0, y: 0.0)
    }
    
    func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        clear()
    }    
}

class AlignmentRule: Rule {
    let factor: CGFloat = 2.0
	let range = 300.0
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

		var boidsInCurrentGroup = 0
        for birdNode in birdNodes {
			if birdNode == targetNode {
				continue
			}

			if distanceBetween(birdNode.position, targetNode.position) > range {
				continue
			}

			boidsInCurrentGroup += 1
			velocity.x += birdNode.velocity.x
			velocity.y += birdNode.velocity.y
        }

        if boidsInCurrentGroup <= 1 {
            return
        }

        velocity.x /= CGFloat(boidsInCurrentGroup)
        velocity.y /= CGFloat(boidsInCurrentGroup)
        
        velocity.x = (velocity.x - targetNode.velocity.x) / factor
        velocity.y = (velocity.y - targetNode.velocity.y) / factor
    }
}

class CohesionRule: Rule {
    var factorX: CGFloat {
		return CGRectGetWidth(frame)
	}

	var factorY: CGFloat {
		return CGRectGetHeight(frame)
	}

	let range = 300.0
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

		var boidsInCurrentGroup = 0
        for birdNode in birdNodes {
            if birdNode == targetNode {
				continue
			}

			if distanceBetween(birdNode.position, targetNode.position) > range {
				continue
			}

			boidsInCurrentGroup += 1
			velocity.x += birdNode.position.x
			velocity.y += birdNode.position.y
        }

        if boidsInCurrentGroup <= 1 {
            return
        }

        velocity.x /= CGFloat(boidsInCurrentGroup)
        velocity.y /= CGFloat(boidsInCurrentGroup)

        velocity.x = (velocity.x - targetNode.position.x) / factorX
        velocity.y = (velocity.y - targetNode.position.y) / factorY
    }
}

class NoiseRule: Rule {
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

        velocity = CGPoint(x:drand48() - 0.5, y:drand48() - 0.5)
    }
}

class SeparationRule: Rule {
    let threshold = 30.0
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

        for birdNode in birdNodes {
            if birdNode != targetNode {
                if distanceBetween(targetNode.position, birdNode.position) < threshold {
                    velocity.x -= birdNode.position.x - targetNode.position.x
                    velocity.y -= birdNode.position.y - targetNode.position.y
                }
            }
        }
    }
}
