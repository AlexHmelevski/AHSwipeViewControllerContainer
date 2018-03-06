//
//  AHSwipeViewControllerContainer.swift
//  AHSwipeController
//
//  Created by Alex Hmelevski on 2018-01-16.
//  Copyright © 2018 Alex Hmelevski. All rights reserved.
//

import Foundation
import UIKit

public enum Direction {
    case left
    case right
    case up
    case down
    
    public init(velocity: CGPoint) {
        
        let isVertical = fabs(velocity.y) > fabs(velocity.x)
        if isVertical {
            self = velocity.y < 0 ? .up : .down
        } else {
            self = velocity.x > 0 ? .right : .left
            
        }
    }
}

enum VerticalDirection {
    case up
    case down
}

public enum ContainerState {
    case left
    case right
    case top
    case bottom
    case root
    case inProgress
}


public final class AHSwipeViewControllerContainer: UIViewController {
    
    public var rightVC: SwipeChildViewController?
    public var leftVC: SwipeChildViewController?
    public var upperVC: SwipeChildViewController?
    public var bottomVC: SwipeChildViewController?
    
    private let rootVC: SwipeChildViewController
    
    // MARK: States
    
    private var state: ContainerState = .root
    private var startPoint: CGPoint = .zero
    private var lockedDirection: Direction = Direction(velocity: .zero)
    
    private var animator: Animator?
    
    private let frameProvider: FrameProvider
    private let percentCalculator: PercentCalculator
    private let alphaProvider: AlphaProvider
    
    public init(rootVC: SwipeChildViewController,
                frameProvider: FrameProvider = AHFrameProvider(),
                calculator: PercentCalculator  = AHPercentCalculator(),
                alphaProvider: AlphaProvider = AHAlphaProvider()) {
        self.rootVC = rootVC
        self.frameProvider = frameProvider
        self.percentCalculator = calculator
        self.alphaProvider = alphaProvider
        super.init(nibName: nil, bundle: nil)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        view.addGestureRecognizer(panGesture)
        
        addNavigation(for: rootVC)
        addBackground(for: rootVC)
        view.addSubview(rootVC.view)
        
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var childViewControllerForStatusBarStyle: UIViewController? { return currentVC }
    public override var childViewControllerForStatusBarHidden: UIViewController? { return currentVC }
    public override func childViewControllerForHomeIndicatorAutoHidden() -> UIViewController? { return currentVC }
    public override func childViewControllerForScreenEdgesDeferringSystemGestures() -> UIViewController? { return currentVC }
    
    
    public func chande(to newState: ContainerState) {
        switch (state, newState) {
        case (_ ,.root):
            if let currentVC = currentVC {
                hide(vc: currentVC, with: newState)
            }
            
        default: break
        }
        animator?.startAutomatic()
    }
    
    
    @objc func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        let vel =  gestureRecognizer.velocity(in: view)
        let point = gestureRecognizer.location(in: view)
        
        let context = PercentCalculatorContext(direction: lockedDirection,
                                               currentPoint: point,
                                               startPoint: startPoint,
                                               contextFrame: view.frame)
        
        switch gestureRecognizer.state {
            
        case .began:
            lockedDirection = Direction(velocity: vel)
            startPoint = point
            if let vc = controllerForAnimation(using: lockedDirection) {
                prepareController(for: lockedDirection, and: state, using: vc)
            }
            
        case .changed:
            animator?.set(completionPercentage: percentCalculator.percent(for: context))
        case .ended:
            let endContext = context.withNewPoint(currentPoint: CGPoint(x: point.x + vel.x, y: point.y + vel.y))
            
            if percentCalculator.percent(for: endContext) < 0.3 {
                animator?.cancel()
            } else {
                animator?.continueAnimation()
            }
            
            startPoint = .zero
            
        case .cancelled: debugPrint("cancelled")
        case .failed: debugPrint("failed")
        case .possible: break
            
        }
    }
    
    private func controllerForAnimation(using direction: Direction)-> SwipeChildViewController? {
        switch (direction,state) {
        case (.left,.root),(.right,.right): return rightVC
        case (.right,.root),(.left,.left): return leftVC
        case (.up,.root),(.down, .bottom): return bottomVC
        case (.down, .root), (.up,.top): return upperVC
        default: return nil
        }
    }
    
    private func prepareController(for direction: Direction,
                                   and state: ContainerState,
                                   using controller: SwipeChildViewController) {
        switch (direction,state) {
        case (.left,.root): show(vc: controller, with: .right)
        case (.right,.root): show(vc: controller, with: .left)
        case (.right,.right): hide(vc: controller, with: .root)
        case (.left,.left): hide(vc: controller, with: .root)
        case (.up, .root): show(vc: controller, with: .bottom)
        case (.down, .bottom): hide(vc: controller, with: .root)
        case (.down, .root): show(vc: controller, with: .top)
        case (.up, .top): hide(vc: controller, with: .root)
        default: break
        }
        
        animator?.startInteractive()
    }
    
    
    
    private func show(vc: SwipeChildViewController,
                      with newState: ContainerState) {
        
        let context = self.context(for: lockedDirection, newState: newState, vc: vc)
        addBackground(for: vc)
        addNavigation(for: vc)
        prepareForShow(vc: vc)
        prepareAnimator(for: vc.view, with: context, completed: {
            self.state = newState
            self.finalizeShow(vc: vc, cancel: false)
        }) {
            self.finalizeShow(vc: vc, cancel: true)
            self.removeNavigation(for: vc)
            self.removeBackground(for: vc)
            vc.view.removeFromSuperview()
            vc.view.frame = self.frameProvider.initialFrame(forContext: context)
        }
        
        animator?.addAnimation({
            vc.alonsideAppearingAnimation?()
            self.controller(for: self.state)?.alonsideDisappearingAnimation?()
        })
        animator?.startInteractive()
    }
    
    private func hide(vc: SwipeChildViewController,
                      with newState: ContainerState) {
        
        let context = self.context(for: lockedDirection, newState: .root, vc: vc)
        
        prepareForHide(vc: vc)
        prepareAnimator(for: vc.view, with: context, completed: {
            self.state = newState
            self.finilizeHide(vc: vc, cancel: false)
            vc.view.removeFromSuperview()
            self.removeNavigation(for: vc)
            self.removeBackground(for: vc)
            
        }) {
            self.addBackground(for: vc)
            self.addNavigation(for: vc)
            self.finilizeHide(vc: vc, cancel: true)
            vc.view.frame = self.frameProvider.initialFrame(forContext: context)
        }
        
        animator?.addAnimation({
            vc.alonsideDisappearingAnimation?()
            self.controller(for: newState)?.alonsideAppearingAnimation?()
        })
        
    }
    
    private func addNavigation(for vc: SwipeChildViewController) {
        guard let nav = vc.navigationView else { return }
        view.insertSubview(nav, belowSubview: vc.view)
        nav.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.1)
    }
    
    private func removeNavigation(for vc: SwipeChildViewController) {
        guard let nav = vc.navigationView else { return }
        nav.removeFromSuperview()
    }
    
    private func addBackground(for vc: SwipeChildViewController) {
        guard let v = vc.backgroundView else { return }
        view.insertSubview(v, belowSubview: vc.view)
        v.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    private func removeBackground(for vc: SwipeChildViewController) {
        guard let v = vc.backgroundView else { return }
        v.removeFromSuperview()
    }
    
    private func prepareForShow(vc: UIViewController) {
        view.addSubview(vc.view)
        addChildViewController(vc)
        rootVC.willMove(toParentViewController: nil)
    }
    
    private func prepareForHide(vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        rootVC.willMove(toParentViewController: self)
    }
    
    private func finalizeShow(vc: UIViewController, cancel: Bool) {
        vc.didMove(toParentViewController: cancel ? nil : self)
        rootVC.didMove(toParentViewController: cancel ? self : nil)
    }
    
    private func finilizeHide(vc: UIViewController, cancel: Bool) {
        rootVC.didMove(toParentViewController: cancel ? nil : self)
        vc.didMove(toParentViewController: cancel ? self : nil)
    }
    
    private func context(for direction: Direction,
                         newState: ContainerState,
                         vc: SwipeChildViewController) -> Context {
        
        return Context(to: newState,
                       from: state,
                       contentSize: view.frame.size,
                       sizeOffsetMultiplier: vc.navigationView != nil ? 0.9 : 1)
    }
    
    private func prepareAnimator(for view: UIView,
                                 with context: Context,
                                 completed: (()->Void)?,
                                 canceled: (()->Void)?) {
        let initFrame = frameProvider.initialFrame(forContext: context)
        let finalFrame = frameProvider.finalFrame(forContext: context)
        view.alpha = self.alphaProvider.initialAlpha(forContext: context)
        animator = Animator(view: view, initFrame: initFrame, finalFrame: finalFrame)
        animator?.addAnimation {
            view.alpha = self.alphaProvider.finalAlpha(forContext: context)
        }
        animator?.cancelCompletion = canceled
        animator?.completed = completed
    }
    
    
    private func controller(for state: ContainerState) -> SwipeChildViewController? {
        switch state {
            case .left: return leftVC
            case .right: return rightVC
            case .root: return rootVC
            case .bottom: return bottomVC
            case .top: return upperVC
        default: return nil
        }
    }
    
    private var currentVC: SwipeChildViewController? {
        return controller(for: state)
    }
}

