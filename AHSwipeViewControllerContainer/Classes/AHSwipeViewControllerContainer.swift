//
//  AHSwipeViewControllerContainer.swift
//  AHSwipeController
//
//  Created by Alex Hmelevski on 2018-01-16.
//  Copyright © 2018 Alex Hmelevski. All rights reserved.
//

import Foundation
import UIKit

enum HorizontalDirection {
    case left
    case right
}

enum VerticalDirection {
    case up
    case down
}

enum ContainerState {
    case left
    case right
    case root
    case inProgress
}


public final class AHSwipeViewControllerContainer: UIViewController {

    public var rightVC: SwipeChildViewController?
    public var leftVC: SwipeChildViewController?

    private let rootVC: SwipeChildViewController
    private var animator: Animator?
    private var state: ContainerState = .root
    private var startPoint: CGPoint = .zero
    private var frameProvider: FrameProvider = FrameProvider()
    
    public init(rootVC: SwipeChildViewController) {
        self.rootVC = rootVC
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
    
    
    @objc func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        
        let vel =  gestureRecognizer.velocity(in: view)
        let direction = AHSwipeDirection(velocity: vel)
        
      
        let point = gestureRecognizer.location(in: view)
        let width = view.bounds.size.width
        let delta = width - startPoint.x
        
        switch gestureRecognizer.state {

            case .began:
       
                startPoint = point
                if let vc = controllerForAnimation(using: direction) {
                    prepareController(for: direction, and: state, using: vc)
                }
            
            
            case .changed:
                let per = percent(for: direction, point: point,initDelta: delta)
                animator?.set(completionPercentage: per)
            
            case .ended:

                if percent(for: direction, point: point,initDelta: delta) < 0.3 {
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
    
    private func controllerForAnimation(using direction: AHSwipeDirection)-> SwipeChildViewController? {
        switch (direction.horizontal,state) {
            case (.left,.root): return rightVC
            case (.right,.root): return leftVC
            case (.right,.right): return rightVC
            case (.left,.left): return leftVC
        default: return nil
        }
    }
    
    private func prepareController(for direction: AHSwipeDirection, and state: ContainerState, using controller: SwipeChildViewController) {
        switch (direction.horizontal,state) {
            case (.left,.root): show(vc: controller, with: .right)
            case (.right,.root): show(vc: controller, with: .left)
            case (.right,.right): hide(vc: controller, with: .root)
            case (.left,.left): hide(vc: controller, with: .root)
        default: break
        }
    }
    
    
    private func percent(for direction: AHSwipeDirection,
                         point: CGPoint,
                         initDelta: CGFloat) -> CGFloat {
         return abs((view.bounds.size.width - point.x - initDelta) / (view.bounds.size.width))

    }
    
    private func show(vc: SwipeChildViewController,
                      with newState: ContainerState) {
        
        let context = self.context(for: .left, newState: newState, vc: vc)
        
        addNavigation(for: vc)
        addBackground(for: vc)
        prepareForShow(vc: vc)
        animateChanges(for: vc.view, with: context, completed: {
            self.state = newState
            self.finalizeShow(vc: vc, cancel: false)
        }) {
            self.finalizeShow(vc: vc, cancel: true)
            self.removeNavigation(for: vc)
            self.removeBackground(for: vc)
            vc.view.removeFromSuperview()
            vc.view.frame = self.frameProvider.initialFrame(forContext: context)
        }
        
        animator?.addAnimation({ vc.alonsideAppearingAnimation?() })
        animator?.start()
    }
    
    private func hide(vc: SwipeChildViewController,
                      with newState: ContainerState) {
        
        let context = self.context(for: .right, newState: .root, vc: vc)

        prepareForHide(vc: vc)
        animateChanges(for: vc.view, with: context, completed: {
            self.state = newState
            self.finilizeHide(vc: vc, cancel: false)
            vc.view.removeFromSuperview()
            self.removeNavigation(for: vc)
            self.removeBackground(for: vc)
            
        }) {
            self.addNavigation(for: vc)
            self.addBackground(for: vc)
            self.finilizeHide(vc: vc, cancel: true)
            vc.view.frame = self.frameProvider.initialFrame(forContext: context)
        }
        
        animator?.addAnimation({ vc.alonsideDisappearingAnimation?() })
        animator?.start()
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
    
    private func context(for direction: HorizontalDirection,
                         newState: ContainerState,
                         vc: SwipeChildViewController) -> Context {
        
        return Context(direction: direction,
                       to: newState,
                       from: state,
                       contentSize: view.frame.size,
                       sizeOffsetMultiplier: vc.navigationView != nil ? 0.9 : 1)
    }
    
    private func animateChanges(for view: UIView,
                                with context: Context,
                                completed: (()->Void)?,
                                canceled: (()->Void)?) {
        let initFrame = frameProvider.initialFrame(forContext: context)
        let finalFrame = frameProvider.finalFrame(forContext: context)
       
         animator = Animator(view: view, initFrame: initFrame, finalFrame: finalFrame)
         animator?.cancelCompletion = canceled
         animator?.completed = completed
    }
    
    
    private var currentVC: SwipeChildViewController? {
        switch state {
            case .left: return leftVC
            case .right: return rightVC
            case .root: return rootVC
        default: return nil
        }
    }
}
