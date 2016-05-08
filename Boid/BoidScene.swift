import SpriteKit

class BoidScene: SKScene {
 
    let numberOfBirds = 10
    
    var birdNodes = [BirdNode]()
    var contentCreated = false
    
    let startWithTouch = false
    
    override func didMoveToView(view: SKView) {
        self.scaleMode = .AspectFit
        backgroundColor = UIColor.blackColor()

        if !startWithTouch {
            self.createSceneContents()
        }
    }
    
    func createSceneContents() {
        if self.contentCreated {
            return
        }

        let degree: Double = 360.0 / Double(self.numberOfBirds)
        let radius = 120.0
        for i in 0..<self.numberOfBirds {
            let birdNode = BirdNode()
            let degree = degree * Double(i)
            let radian = degreeToRadian(degree)
            let x = Double(CGRectGetMidX(self.frame)) + cos(radian) * radius
            let y = Double(CGRectGetMidY(self.frame)) + sin(radian) * radius
            birdNode.position = CGPoint(x: x, y: y)
            
            self.addChild(birdNode)
            self.birdNodes.append(birdNode)
        }
        
        self.contentCreated = true
    }
    
    override func update(currentTime: NSTimeInterval) {
        for birdNode in self.birdNodes {
            birdNode.update(birdNodes: self.birdNodes, frame: self.frame)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)

		self.createSceneContents()

		let birdNode = BirdNode()
		let touch = touches.first!
		let height = self.view!.frame.size.height
		var position = touch.locationInView(self.view)
		position.y = height - position.y
		birdNode.position = position
            
		self.addChild(birdNode)
		self.birdNodes.append(birdNode)
    }
}
