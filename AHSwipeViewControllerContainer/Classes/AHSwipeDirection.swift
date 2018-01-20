//
//  AHSwipeDirection.swift
//  AHSwipeController
//
//  Created by Alex Hmelevski on 2018-01-19.
//  Copyright © 2018 Alex Hmelevski. All rights reserved.
//

import Foundation
import UIKit

struct AHSwipeDirection {
    let horizontal: HorizontalDirection
    let vertical: VerticalDirection
    
    init(velocity: CGPoint) {
        horizontal = velocity.x > 0 ? .right : .left
        vertical = velocity.y < 0 ? .up : .down
    }
}
