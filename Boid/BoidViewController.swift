import SpriteKit

class BoidViewController: UIViewController {

    override func loadView() {
        let applicationFrame = UIScreen.mainScreen().bounds
        let skView = SKView(frame: applicationFrame)
        view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let skView = view as? SKView {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsDrawCount = true
            //skView.showsPhysics = true
            //skView.showsFields = true
            skView.showsQuadCount = true

            skView.ignoresSiblingOrder = true

            let scene = BoidScene(size: CGSize(width: CGRectGetWidth(skView.bounds), height: CGRectGetHeight(skView.bounds)))
            skView.presentScene(scene)
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
