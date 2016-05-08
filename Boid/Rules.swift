import UIKit

class Rule: NSObject {
    var velocity: CGPoint!
    var weight: CGFloat

    var weighted: CGPoint {
        return CGPoint(x: self.velocity.x * self.weight, y: self.velocity.y * self.weight)
    }

    init(weight: CGFloat) {
        self.weight = weight
        super.init()
        self.clear()
    }
    
    func clear() {
        self.velocity = CGPoint(x: 0.0, y: 0.0)
    }
    
    func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        self.clear()
    }    
}

class AlignmentRule: Rule {
    let factor: CGFloat = 2.0
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

        for birdNode in birdNodes {
            if birdNode != targetNode {
                self.velocity.x += birdNode.velocity.x
                self.velocity.y += birdNode.velocity.y
            }
        }
        
        self.velocity.x /= CGFloat(birdNodes.count - 1)
        self.velocity.y /= CGFloat(birdNodes.count - 1)
        
        self.velocity.x = (self.velocity.x - targetNode.velocity.x) / self.factor
        self.velocity.y = (self.velocity.y - targetNode.velocity.y) / self.factor
    }
}

class CohesionRule: Rule {
    let factor: CGFloat = 300.0
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)
        
        for birdNode in birdNodes {
            if birdNode != targetNode {
                self.velocity.x += birdNode.position.x
                self.velocity.y += birdNode.position.y
            }
        }
        
        self.velocity.x /= CGFloat(birdNodes.count - 1)
        self.velocity.y /= CGFloat(birdNodes.count - 1)
        
        self.velocity.x = (self.velocity.x - targetNode.position.x) / self.factor
        self.velocity.y = (self.velocity.y - targetNode.position.y) / self.factor
    }
}

class SeparationRule: Rule {
    let threshold = 30.0
    
    override func evaluate(targetNode targetNode: BirdNode, birdNodes: [BirdNode]) {
        super.evaluate(targetNode: targetNode, birdNodes: birdNodes)

        for birdNode in birdNodes {
            if birdNode != targetNode {
                if distanceBetween(targetNode.position, birdNode.position) < self.threshold {
                    self.velocity.x -= birdNode.position.x - targetNode.position.x
                    self.velocity.y -= birdNode.position.y - targetNode.position.y
                }
            }
        }
    }
}
