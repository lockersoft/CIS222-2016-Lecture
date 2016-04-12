//
//  MainMenu.swift
//  spacedroids2015
//
//  Created by Jones, Dave on 4/6/16.
//  Copyright © 2016 Jones, Dave. All rights reserved.
//

import SpriteKit

class MainMenu : SKScene {
  
  
  var playButton : SKSpriteNode?
  var optionsButton : SKSpriteNode?
  var sound = SKAction.playSoundFileNamed("scifi10", waitForCompletion: false)
  
  override func didMoveToView(view: SKView) {
    playButton = self.childNodeWithName("PlayMenu") as! SKSpriteNode!
    optionsButton = self.childNodeWithName("OptionsMenu") as! SKSpriteNode!
        
  }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
          let location = touch.locationInNode(self)
          print( "x: \(location.x) y: \(location.y)" )
          print( nodeAtPoint(location).name )
          
          if( nodeAtPoint(location).name == playButton!.name ){
            print( "Clicked the play button" )
            let gameScene = GameScene( fileNamed: "GameScene" )
            
            gameScene?.scaleMode = .AspectFill
            self.view?.presentScene(gameScene!, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))
          }
          
          if( nodeAtPoint(location).name == optionsButton!.name ){
            print( "Clicked the Options button")
            // Load the Options Scene
            let optionScene = OptionsMenu( fileNamed: "OptionsMenu" )
            
            runAction(sound)
            optionScene?.scaleMode = .AspectFill
            self.view?.presentScene(optionScene!, transition: SKTransition.doorsOpenHorizontalWithDuration(1.0))
          }
          
        }
    }
}
