//
//  Animator.swift
//  AHSwipeController
//
//  Created by Alex Hmelevski on 2018-01-19.
//  Copyright © 2018 Alex Hmelevski. All rights reserved.
//

import Foundation
import UIKit

public struct Context {
//    let direction: Direction
    let to: ContainerState
    let from: ContainerState
    let contentSize: CGSize
    let sizeOffsetMultiplier: CGFloat
}

final class Animator {
    
    private let animator: UIViewPropertyAnimator
    private weak var view: UIView?
    private let initialFrame: CGRect
    var cancelCompletion: (()->Void)?
    var completed: (()->Void)?
    
    
    init(view: UIView, initFrame: CGRect, finalFrame: CGRect) {
        view.frame = initFrame
        self.view  = view
        self.initialFrame = initFrame
        
        animator = UIViewPropertyAnimator()
        animator.addAnimations {
            view.frame = finalFrame
        }
     
        animator.addCompletion { [weak self] in self?.callCompletions(for: $0) }
    }
    
    
    func start() {
        animator.startAnimation()
        animator.pauseAnimation()
    }
    
    private func callCompletions(for postition: UIViewAnimatingPosition) {
        switch postition {
        case .end: completed?()
        case .start: cancelCompletion?()
        case .current: break
        }
    }
    
    func set(completionPercentage: CGFloat) {
        animator.fractionComplete = completionPercentage
    }
    
    func continueAnimation() {
        let timingParameters = UICubicTimingParameters(animationCurve: .linear)
        animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: 1)
        
    }
    
    func addAnimation(_ animation: @escaping AnimationBlock) {
        animator.addAnimations(animation)
    }
    
    func cancel() {
        animator.isReversed = true
        continueAnimation()
    }
}


