import SpriteKit

class BoidScene: SKScene {
 
    let numberOfBirds = 10
    
    var birdNodes = [BirdNode]()
    var contentCreated = false
    
    let startWithTouch = false

	var timer: NSTimer!

	var screenFrame: CGRect!
    
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFit
        backgroundColor = UIColor.blackColor()

		screenFrame = view.frame

        if !startWithTouch {
            createSceneContents()
        }

		timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(killBoids), userInfo: nil, repeats: true)
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

	func spawnBoid() {

	}

	func killBoids() {
		var count = 0
		for birdNode in birdNodes {
			if shouldBoidDie(birdNode, birdNodes: birdNodes) {
				birdNode.prepareToDie()
				count += 1
				if count > 2 {
					break
				}
			}
        }

		delay(1.5) {
			let shouldDie = self.birdNodes.filter {$0.shouldDie}
			let newGeneration = self.birdNodes.filter {!$0.shouldDie}

			self.removeChildrenInArray(shouldDie)
			self.birdNodes = newGeneration
		}
	}

	func shouldBoidDie(boid:BirdNode, birdNodes: [BirdNode]) -> Bool {
		let range = 300.0
		var boidsInCurrentGroup = 0

        for birdNode in birdNodes {
            if birdNode == boid {
				continue
			}

			if distanceBetween(birdNode.position, boid.position) > range {
				continue
			}

			boidsInCurrentGroup += 1
        }

		if boidsInCurrentGroup > 10 {
			return true
		}
		else {
			return false
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
