//
//  GameUtils.swift
//  spacedroids2015
//
//  Created by Jones, Dave on 4/12/16.
//  Copyright © 2016 Jones, Dave. All rights reserved.
//

import Foundation
import SpriteKit

func degreesToRadians( degrees : CGFloat ) -> CGFloat {
    return CGFloat(degrees * CGFloat(M_PI) / 180.0)
}

struct PhysicsCategory {
    static let None     : UInt32 = 0
    static let All      : UInt32 = UINT32_MAX
    static let Asteroid : UInt32 = 0b1              // 1
    static let PhaserShot : UInt32 = 0b10           // 2
    static let LaserShot : UInt32 = 0b100           // 4
    static let SpaceShip : UInt32 = 0b1000          // 8
}