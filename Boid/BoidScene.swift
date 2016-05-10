import SpriteKit

class BoidScene: SKScene {
 
    let numberOfBirds = 10
    
    var birdNodes = [BirdNode]()
    var contentCreated = false
    
    let startWithTouch = false

	var screenFrame: CGRect!
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFit
        backgroundColor = UIColor.blackColor()

		screenFrame = view.frame

        if !startWithTouch {
            createSceneContents()
        }
    }
    
    func createSceneContents() {
        if contentCreated {
            return
        }

        let degree: Double = 360.0 / Double(numberOfBirds)
        let radius = 120.0
        for i in 0..<numberOfBirds {
            let birdNode = BirdNode(frame: screenFrame)
            let degree = degree * Double(i)
            let radian = degreeToRadian(degree)
            let x = Double(CGRectGetMidX(frame)) + cos(radian) * radius
            let y = Double(CGRectGetMidY(frame)) + sin(radian) * radius
            birdNode.position = CGPoint(x: x, y: y)
            
            addChild(birdNode)
            birdNodes.append(birdNode)
        }
        
        contentCreated = true
    }
    
    override func update(currentTime: NSTimeInterval) {
        for birdNode in birdNodes {
            birdNode.update(birdNodes: birdNodes, frame: frame)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)

		createSceneContents()

		let birdNode = BirdNode(frame: screenFrame)
		let touch = touches.first!
		let height = view!.frame.size.height
		var position = touch.locationInView(view)
		position.y = height - position.y
		birdNode.position = position
            
		addChild(birdNode)
		birdNodes.append(birdNode)
    }
}
