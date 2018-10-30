//
//  GameScene.swift
//  SKMonday
//
//  Created by localadmin on 30.10.18.
//  Copyright © 2018 ch.cqd.skmonday. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum categories {
        static let noCat:UInt32 = 0
        static let laserCat:UInt32 = 0b1
        static let playerCat:UInt32 = 0b1 << 1
        static let astroidCat:UInt32 = 0b1 << 2
        static let gravityCat: UInt32 = 0b1 << 3
        static let astroidField: UInt32 = 0b1 << 4
    }
    
    var player: SKSpriteNode?
    var laser: SKSpriteNode?
    var astroid: SKSpriteNode?
    var gravityNode: SKFieldNode?
    var longPress: TimeInterval!
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact \(contact.bodyA.node?.name) \(contact.bodyB.node?.name)")
    }
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        print("contact \(contact.bodyA.node?.name) \(contact.bodyB.node?.name)")
//        contact.bodyA.node?.removeFromParent()
//        contact.bodyB.node?.removeFromParent()
//    }
    
    override func didMove(to view: SKView) {
        scene?.physicsWorld.contactDelegate = self
        let degreesToRadians = CGFloat.pi / 180
        let radiansToDegrees = 180 / CGFloat.pi
        
        player = SKSpriteNode(imageNamed: "player")
        player?.position = CGPoint(x: self.view!.bounds.minX, y: self.view!.bounds.minY)
        player?.physicsBody = SKPhysicsBody(rectangleOf: player!.size)
        player?.physicsBody?.isDynamic = false
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.allowsRotation = false
        // category that this physics body belongs too
        player?.physicsBody?.categoryBitMask = categories.playerCat
        // category that defines which bodies will react it
        player?.physicsBody?.collisionBitMask = categories.noCat
        // respond with cause delegate calls
        player?.physicsBody?.contactTestBitMask = categories.astroidCat
        player?.name = "player"
        player?.zRotation = -90 * degreesToRadians
        addChild(player!)
        spawnAstroid()
        
        let gravityVector = vector_float3(0,-1,0)
        gravityNode = SKFieldNode.linearGravityField(withVector: gravityVector)
        gravityNode!.strength = 1.0
        
        gravityNode!.isEnabled = true
        
        //        physicsWorld.gravity = CGVector(dx:0, dy: 0)
        physicsWorld.gravity = CGVector(dx:0, dy: 0)
        addChild(gravityNode!)
        
        gravityNode?.physicsBody?.categoryBitMask = categories.gravityCat
        gravityNode?.physicsBody?.collisionBitMask = categories.noCat
        gravityNode?.physicsBody?.contactTestBitMask = categories.laserCat
        
        
        
        let joinMe = SKFieldNode.radialGravityField()
        joinMe.strength = 1
        joinMe.isEnabled = true
        
        joinMe.physicsBody?.categoryBitMask = categories.astroidField
        joinMe.physicsBody?.collisionBitMask = categories.noCat
        joinMe.physicsBody?.contactTestBitMask = categories.playerCat
        joinMe.physicsBody?.fieldBitMask = categories.astroidField
        player?.addChild(joinMe)
//        joinMe.categoryBitMask = categories.astroidCat
//        player?.addChild(joinMe)
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        let degreesToRadians = CGFloat.pi / 180
        let radiansToDegrees = 180 / CGFloat.pi
        
        
//        longPress = Date().timeIntervalSinceReferenceDate - 0

//        let angleInRadians = GLKMathDegreesToRadians(6)
//        let rotateAction = SKAction.rotate(byAngle: CGFloat(angleInRadians), duration: 0)
//        player?.run(rotateAction)
        
        var angleRightNow = (player?.zRotation)!
//        angleRightNow -= 90 * degreesToRadians
        let cordX = cos(angleRightNow)
        let cordY = sin(angleRightNow)
        spawnLaser(direction: CGVector(dx: cordX, dy: cordY), angle: angleRightNow)

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        let pressed = Date().timeIntervalSinceReferenceDate - longPress
//        print("pressed \(pressed)")
        let angleInRadians = GLKMathDegreesToRadians(6)
        let rotateAction = SKAction.rotate(byAngle: CGFloat(angleInRadians), duration: 0)
        player?.run(rotateAction)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func spawnLaser(direction: CGVector, angle: CGFloat ){
//        scene?.physicsWorld.gravity = direction
        gravityNode?.zRotation = angle
        let laserColor:UIColor = UIColor(displayP3Red: 41.0 / 255.0, green: 184.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
        laser = SKSpriteNode(color: laserColor, size: CGSize(width: 7, height: 7))
        laser?.position = player!.position
        self.addChild(laser!)
        
        laser?.physicsBody = SKPhysicsBody(rectangleOf: laser!.size)
        laser?.physicsBody?.isDynamic = true
        laser?.physicsBody?.allowsRotation = true
        laser?.physicsBody?.affectedByGravity = true
        laser?.physicsBody?.friction = 0.0
        laser?.physicsBody?.restitution = 0.0
        laser?.physicsBody?.angularDamping = 0.0
        laser?.physicsBody?.mass = 0.006
        laser?.physicsBody?.linearDamping = 0
//        laser?.physicsBody?.velocity = CGVector(dx: 0, dy: 500)
//        laser?.physicsBody?.velocity = direction
        laser?.physicsBody?.categoryBitMask = categories.laserCat
        laser?.physicsBody?.collisionBitMask = categories.noCat
        laser?.physicsBody?.contactTestBitMask = categories.astroidCat
        laser?.physicsBody?.fieldBitMask = categories.gravityCat
        laser?.name = "laser"
    }
    
    func spawnAstroid() {
        astroid = SKSpriteNode(imageNamed: "astroid")
        let randX = GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.view!.bounds.maxX))
        let randY = GKRandomSource.sharedRandom().nextInt(upperBound: Int(self.view!.bounds.maxY))
        astroid?.position = CGPoint(x: randX, y: randY)
        astroid?.scale(to: CGSize(width: 200, height: 100))
        astroid?.physicsBody = SKPhysicsBody(rectangleOf: astroid!.size)
        astroid?.physicsBody?.isDynamic = true
        astroid?.physicsBody?.allowsRotation = true
        astroid?.physicsBody?.affectedByGravity = false
        astroid?.physicsBody?.friction = 0.0
        astroid?.physicsBody?.restitution = 0.0
        astroid?.physicsBody?.angularDamping = 0.0
        astroid?.physicsBody?.mass = 0.006
        astroid?.physicsBody?.linearDamping = 0
        //        laser?.physicsBody?.velocity = CGVector(dx: 0, dy: 500)
        //        laser?.physicsBody?.velocity = direction
        astroid?.physicsBody?.categoryBitMask = categories.astroidCat
        astroid?.physicsBody?.collisionBitMask = categories.noCat
        astroid?.physicsBody?.contactTestBitMask = categories.playerCat | categories.laserCat
        astroid?.physicsBody?.fieldBitMask = categories.astroidField
        astroid?.name = "astroid"
        self.addChild(astroid!)
    }
    
    func splitAstroid() {
        
    }
}
