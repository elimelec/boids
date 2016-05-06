import UIKit

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
