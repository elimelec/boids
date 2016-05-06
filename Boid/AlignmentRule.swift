import UIKit

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
