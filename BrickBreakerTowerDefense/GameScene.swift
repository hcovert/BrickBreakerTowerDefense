
//12.0 compatible
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var ball: SKSpriteNode!
    private var paddle: SKSpriteNode!
    private var bricks = [SKSpriteNode]()

    override func didMove(to view: SKView) {
        setupPhysics()
        createBall()
        createPaddle()
        createBricks()
    }

    private func setupPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 2, dy: 2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0
        physicsBody?.restitution = 1.0
    }

    private func createBall() {
        let ballTexture = SKTexture(imageNamed: "BallSprite")
        ball = SKSpriteNode(texture: ballTexture)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.categoryBitMask = 0x1 << 0
        ball.physicsBody?.contactTestBitMask = 0x1 << 1
        ball.physicsBody?.collisionBitMask = 0x1 << 1
        addChild(ball)

        // Apply an initial impulse to the ball
        ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
    }

    private func createPaddle() {
        paddle = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.categoryBitMask = 0x1 << 1
        paddle.physicsBody?.contactTestBitMask = 0x1 << 0
        paddle.physicsBody?.collisionBitMask = 0x1 << 0
        addChild(paddle)
    }

    private func createBricks() {
        let brickWidth: CGFloat = 50
        let brickHeight: CGFloat = 20
        let numRows = 5
        let numCols = Int(frame.width / brickWidth)
        let xOffset = (frame.width - brickWidth * CGFloat(numCols)) / 2

        for row in 0..<numRows {
            for col in 0..<numCols {
                let brick = SKSpriteNode(color: .red, size: CGSize(width: brickWidth, height: brickHeight))
                brick.position = CGPoint(x: xOffset + brickWidth * CGFloat(col), y: frame.maxY - brickHeight * CGFloat(row))
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.categoryBitMask = 0x1 << 1
                brick.physicsBody?.contactTestBitMask = 0x1 << 0
                brick.physicsBody?.collisionBitMask = 0x1 << 0
                addChild(brick)
                bricks.append(brick)
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            if nodeA == ball {
                if let index = bricks.firstIndex(of: nodeB as! SKSpriteNode) {
                    bricks.remove(at: index)
                    nodeB.removeFromParent()
                    // Handle brick collision
                }
            } else if nodeB == ball {
                if let index = bricks.firstIndex(of: nodeA as! SKSpriteNode) {
                    bricks.remove(at: index)
                    nodeA.removeFromParent()
                    // Handle brick collision
                }
            }
        }
    }
}
