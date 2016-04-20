//
//  Asteroid.swift
//  spacedroids2015
//
//  Created by Jones, Dave on 4/14/16.
//  Copyright © 2016 Jones, Dave. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
  var pos = CGPoint(x: 0, y: 0)
  var textureAtlas = SKTextureAtlas()
  var asteroidAnimation = [SKTexture]()
  var animateAsteroidAction = SKAction()
  
  init( pos : CGPoint ){
    self.pos = pos
    var texture = SKTexture(imageNamed: "aLarge0.png")
    super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    
    // Add an animated sprite
    textureAtlas = SKTextureAtlas(named: "LargeAsteroid.atlas")
    for i in 0..<15 {
      let name = "aLarge\(i)"
      asteroidAnimation.append(SKTexture(imageNamed: name))
    }
    animateAsteroidAction = SKAction.animateWithTextures(asteroidAnimation, timePerFrame: 0.08 )
    
    self.position = pos
    
    self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 5)
    self.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
    self.physicsBody?.collisionBitMask = PhysicsCategory.All
    self.name = "Asteroid"
    self.runAction(SKAction.repeatActionForever(animateAsteroidAction) )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
