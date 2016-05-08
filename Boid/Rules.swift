import UIKit

class Rule: NSObject {
    var velocity: CGPoint!
    var weight: CGFloat

    var weighted: CGPoint {
        return CGPoint(x: velocity.x * weight, y: velocity.y * weight)
    }

    init(weight: CGFloat) {
        self.weight = weight
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
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

        for birdNode in birdNodes {
            if birdNode != targetNode {
                velocity.x += birdNode.velocity.x
                velocity.y += birdNode.velocity.y
            }
        }

        if birdNodes.count <= 1 {
            return
        }

        velocity.x /= CGFloat(birdNodes.count - 1)
        velocity.y /= CGFloat(birdNodes.count - 1)
        
        velocity.x = (velocity.x - targetNode.velocity.x) / factor
        velocity.y = (velocity.y - targetNode.velocity.y) / factor
    }
}

class CohesionRule: Rule {
    let factor: CGFloat = 300.0
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

        for birdNode in birdNodes {
            if birdNode != targetNode {
                velocity.x += birdNode.position.x
                velocity.y += birdNode.position.y
            }
        }

        if birdNodes.count <= 1 {
            return
        }

        velocity.x /= CGFloat(birdNodes.count - 1)
        velocity.y /= CGFloat(birdNodes.count - 1)
        
        velocity.x = (velocity.x - targetNode.position.x) / factor
        velocity.y = (velocity.y - targetNode.position.y) / factor
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
