//
//  GameScene.swift
//  spacedroids2015
//
//  Created by Jones, Dave on 4/6/16.
//  Copyright (c) 2016 Jones, Dave. All rights reserved.
//

import SpriteKit

var ship : SKSpriteNode!
let rotateGesture = UIRotationGestureRecognizer()
var rotationOffset : CGFloat = 0.0

class GameScene: SKScene {
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    
    rotateGesture.addTarget( self, action: "rotateShip:" )
    self.view!.addGestureRecognizer(rotateGesture)
    
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    myLabel.text = "Hello, World!"
    myLabel.fontSize = 45
    myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
    
    self.addChild(myLabel)
    
    ship = SKSpriteNode(imageNamed:"Spaceship")
    ship.xScale = 0.5
    ship.yScale = 0.5
    ship.position = CGPoint(x: 200,y: 200)
    self.addChild(ship)
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
}
