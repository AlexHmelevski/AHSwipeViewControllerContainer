//
//  AHSwipeDirection.swift
//  AHSwipeController
//
//  Created by Alex Hmelevski on 2018-01-19.
//  Copyright © 2018 Alex Hmelevski. All rights reserved.
//

import Foundation
import UIKit

public struct AHSwipeDirection {
    let direction: Direction

    
    init(velocity: CGPoint) {
        
        let isVertical = fabs(velocity.y) > fabs(velocity.x)
    
        
        if isVertical {
            direction = velocity.y < 0 ? .up : .down
        } else {
            direction = velocity.x > 0 ? .right : .left
            
        }
    }
}
