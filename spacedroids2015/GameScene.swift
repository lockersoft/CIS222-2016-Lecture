//
//  GameScene.swift
//  spacedroids2015
//
//  Created by Jones, Dave on 4/6/16.
//  Copyright (c) 2016 Jones, Dave. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
          
          let action = SKAction.rotateByAngle(degreesToRadians(180), duration:0.5)
          let vector = CGVector(dx: -1, dy: 1)
          
          let moveAction = SKAction.moveBy(vector, duration: 0.1)
          let scaleAction = SKAction.scaleBy(0.1, duration: 1)
          let sequence = SKAction.sequence([action,moveAction, scaleAction,moveAction,scaleAction,action])
          
          sprite.runAction(SKAction.repeatActionForever(sequence))
            
          self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
