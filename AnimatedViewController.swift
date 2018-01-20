//
//  AnimatedViewController.swift
//  AHSwipeController
//
//  Created by Alex Hmelevski on 2018-01-19.
//  Copyright © 2018 Alex Hmelevski. All rights reserved.
//

import Foundation
import UIKit

public typealias AnimationBlock = ()->Void

public protocol AnimatedViewController {
    var navigationView: UIView? { get }
    var backgroundView: UIView? { get }
    
    var alonsideAppearingAnimation: AnimationBlock? { get }
    var alonsideDisappearingAnimation: AnimationBlock? { get }
}

public typealias SwipeChildViewController = UIViewController & AnimatedViewController
