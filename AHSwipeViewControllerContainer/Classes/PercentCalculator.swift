//
//  PercentCalculator.swift
//  AHSwipeViewControllerContainer
//
//  Created by Alex Hmelevski on 2018-02-02.
//

import Foundation


public struct PercentCalculatorContext {
    let direction: Direction
    let currentPoint: CGPoint
    let startPoint: CGPoint
    let contextFrame: CGRect
    
    func withNewPoint(currentPoint: CGPoint) -> PercentCalculatorContext {
        return PercentCalculatorContext(direction: direction,
                                        currentPoint: currentPoint,
                                        startPoint: startPoint,
                                        contextFrame: contextFrame)
    }
}

public protocol PercentCalculator {
    func percent(for context: PercentCalculatorContext) -> CGFloat
}


public final class AHPercentCalculator: PercentCalculator {
    
    public init() {}
    
    public func percent(for context: PercentCalculatorContext) -> CGFloat {
        let delta =  self.delta(for: context.direction, size: context.contextFrame.size, startPoint: context.startPoint)
        return percent(for: context.currentPoint, with: delta, using: context.direction, contextSize: context.contextFrame.size)
    }
    
    private func delta(for direction: Direction, size: CGSize, startPoint: CGPoint) -> CGFloat {
        switch direction {
            case .left: return size.width - startPoint.x
            case .right: return startPoint.x
            case .up: return size.height - startPoint.y
            case .down: return startPoint.y
        }
    }
    
    private func percent(for currentPoint: CGPoint,
                         with delta: CGFloat,
                         using direction: Direction,
                         contextSize: CGSize) -> CGFloat {
        
        switch direction {
            case .left: return (contextSize.width - currentPoint.x - delta) / contextSize.width
            case .right: return  (currentPoint.x - delta) / contextSize.width
            case .up: return (contextSize.height - currentPoint.y - delta) / contextSize.height
            case .down: return (currentPoint.y - delta) / contextSize.height
            
        }
    }
}
