//
//  OptionsMenu.swift
//  spacedroids2015
//
//  Created by Jones, Dave on 4/11/16.
//  Copyright © 2016 Jones, Dave. All rights reserved.
//

import SpriteKit

class OptionsMenu : SKScene {
  
  var backButton : SKSpriteNode?
  
  override func didMoveToView(view: SKView) {
    backButton = self.childNodeWithName("BackToMain") as! SKSpriteNode!
  }
    
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    for touch in touches {
      let location = touch.locationInNode(self)
      print( "x: \(location.x) y: \(location.y)" )
      print( nodeAtPoint(location).name )
      
      if( nodeAtPoint(location).name == backButton!.name ){
        print( "Clicked the Back to Main button" )
        let mainMenuScene = MainMenu( fileNamed: "MainMenu")
        
        mainMenuScene?.scaleMode = .AspectFill
        self.view?.presentScene(mainMenuScene!, transition: SKTransition.doorsCloseHorizontalWithDuration(1.0))
      }
    }
  }

}
