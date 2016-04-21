//
//  GameScene.swift
//  spacedroids2015
//
//  Created by Jones, Dave on 4/6/16.
//  Copyright (c) 2016 Jones, Dave. All rights reserved.
//

import SpriteKit

var ship : SKSpriteNode!
var asteroid : SKSpriteNode!

let rotateGesture = UIRotationGestureRecognizer()
var rotationOffset : CGFloat = 0.0
var textureAtlas = SKTextureAtlas()
var asteroidAnimation = [SKTexture]()
var animateAsteroidAction = SKAction()

var explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
var phaserSound = SKAction.playSoundFileNamed("scifi10.mp3", waitForCompletion: false)

var scoreNode = SKLabelNode()
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    
    self.physicsWorld.contactDelegate = self
    scoreNode = self.childNodeWithName("score")! as! SKLabelNode
    
    rotateGesture.addTarget( self, action: "rotateShip:" )
    self.view!.addGestureRecognizer(rotateGesture)
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    myLabel.text = "Hello, World!"
    myLabel.fontSize = 45
    myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
    
    self.addChild(myLabel)
    
    ship = SKSpriteNode(imageNamed:"Spaceship")
    ship.name = "Ship"
    ship.xScale = 0.5
    ship.yScale = 0.5
    ship.position = CGPoint(x: 200,y: 200)
    ship.zPosition = 100
    
    ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width / 3)
    ship.physicsBody?.categoryBitMask = PhysicsCategory.SpaceShip
    ship.physicsBody?.collisionBitMask = PhysicsCategory.Asteroid
    ship.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
    
    self.addChild(ship)
    
    self.addChild(Asteroid(pos: CGPoint(x: -200, y: 200)))
    self.addChild(Asteroid(pos: CGPoint(x: -100, y: 200)))
    self.addChild(Asteroid(pos: CGPoint(x: -300, y: 200)))
    
  }
  
  func createPhaserShot(){
    let phaserShot = SKSpriteNode(imageNamed: "phaserLarge")
    phaserShot.xScale = 0.1
    phaserShot.yScale = 0.1
    phaserShot.position = ship!.position
    phaserShot.zRotation = ship!.zRotation
    phaserShot.name = "PhaserShot"
    
    phaserShot.physicsBody = SKPhysicsBody(circleOfRadius: phaserShot.size.width)
    phaserShot.physicsBody?.categoryBitMask = PhysicsCategory.PhaserShot
    phaserShot.physicsBody?.collisionBitMask = PhysicsCategory.Asteroid & PhysicsCategory.PhaserShot
    phaserShot.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid | PhysicsCategory.PhaserShot
    
    /*
    0000 0001   // Phaser
    0000 1000   // Asteroid
    0000 0000   AND  &  8 & 1  ==> 0
    0000 1001   OR   |  8 | 1  ==> 9
    */
    
    
    let ninetyDegrees = degreesToRadians(90.0)
    let xDist = (cos(phaserShot.zRotation + ninetyDegrees ) * 1000) + phaserShot.position.x
    let yDist = (sin(phaserShot.zRotation + ninetyDegrees) * 1000) + phaserShot.position.y
    
    let moveAction = SKAction.moveTo(CGPointMake(xDist, yDist), duration: 2 )
    //   let sequence = SKAction.sequence([ moveAction, SKAction.removeFromParent()])
    phaserShot.runAction( SKAction.sequence(
      [
        phaserSound,
        moveAction,
        SKAction.removeFromParent()
      ]) )
    addChild(phaserShot)
  }
  
  func rotateShip(gesture: UIRotationGestureRecognizer){
    print("Rotating: \(gesture.rotation)")
    if( gesture.state == .Changed ){
      ship!.zRotation = -gesture.rotation + rotationOffset
    }
    if( gesture.state == .Ended ){
      rotationOffset = ship!.zRotation
    }
  }
  
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    
    for touch in touches {
      let location = touch.locationInNode(self)
      let vector = CGVector(dx: -1, dy: 1)
      
      let moveAction = SKAction.moveTo(location, duration: 0.5)
      ship.runAction( moveAction )
      
      createPhaserShot()
      
      /*
      let action = SKAction.rotateByAngle(degreesToRadians(180), duration:0.5)
      let vector = CGVector(dx: -1, dy: 1)
      
      let moveAction = SKAction.moveBy(vector, duration: 0.1)
      let scaleAction = SKAction.scaleBy(0.1, duration: 1)
      let sequence = SKAction.sequence([action,moveAction, scaleAction,moveAction,scaleAction,action])
      
      ship.runAction(SKAction.repeatActionForever(sequence))
      */
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
    print( contact.bodyA.node?.name, contact.bodyB.node?.name )
    
    /*    if (
    ((contact.bodyA.categoryBitMask == PhysicsCategory.Asteroid) &&
    (contact.bodyB.categoryBitMask == PhysicsCategory.PhaserShot)) ||
    ((contact.bodyA.categoryBitMask == PhysicsCategory.PhaserShot) &&
    (contact.bodyB.categoryBitMask == PhysicsCategory.Asteroid))
    ) {
    */
    let bodyA = contact.bodyA.node!
    let bodyB = contact.bodyB.node!
    
    if( (bodyA.name == "Asteroid" && bodyB.name == "PhaserShot") ||
      (bodyB.name == "Asteroid" && bodyA.name == "PhaserShot")){
        self.addChild( explode( contact.contactPoint ) )
        contact.bodyA.node!.removeFromParent()
        contact.bodyB.node!.removeFromParent()
        gameScore += 5
        scoreNode.text = "Score: " + String(gameScore)
    }
  }
}

func explode( location: CGPoint ) -> SKEmitterNode {
  var explosion : SKEmitterNode = SKEmitterNode()
  if let burstPath  = NSBundle.mainBundle().pathForResource("asteroidExplosion", ofType: "sks"){
    explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(burstPath) as! SKEmitterNode
    
    explosion.position = location
    explosion.name = "asteroidExplode"
    
    explosion.runAction(SKAction.sequence([
      explosionSound,
      SKAction.waitForDuration(0.5),
      SKAction.fadeAlphaTo(0.0, duration: 0.3),
      SKAction.removeFromParent()
      ]))
  }
  return explosion
}
