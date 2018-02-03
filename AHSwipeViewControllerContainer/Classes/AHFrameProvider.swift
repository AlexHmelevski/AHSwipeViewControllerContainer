//
//  FrameProvider.swift
//  AHSwipeController
//
//  Created by Alex Hmelevski on 2018-01-19.
//  Copyright © 2018 Alex Hmelevski. All rights reserved.
//

import Foundation
import UIKit

public protocol FrameProvider {
    func initialFrame(forContext context: Context) -> CGRect
    func finalFrame(forContext context: Context) -> CGRect
}


public final class AHFrameProvider: FrameProvider {
    
    public init() {}
    public func initialFrame(forContext context: Context) -> CGRect {
        
        let width = self.width(from: context)
        
        let adjustedHeight = height(from: context)
        let yOffset = self.yOffset(from: context)
        
        switch (context.to, context.from) {
        case (.right, .root): return CGRect(x: width,
                                            y: yOffset,
                                            width: width,
                                            height: adjustedHeight)
            
        case (.root,.right),
             (.root, .left),
             (.top,.root): return CGRect(x: 0,
                                           y: yOffset,
                                           width: width,
                                           height: adjustedHeight)
        case (.left,.root): return CGRect(x: -width,
                                          y: yOffset,
                                          width: width,
                                          height: adjustedHeight)
            
        case (.bottom,.root): return CGRect(x: 0,
                                         y: yOffset + adjustedHeight,
                                         width: width,
                                         height: adjustedHeight)
        case (.root,.bottom),
             (.root,.top):    return CGRect(x: 0,
                                            y: yOffset,
                                            width: width,
                                            height: adjustedHeight)
            
        
        default: fatalError()
        }
    }
    
    public func finalFrame(forContext context: Context) -> CGRect {
        let width = self.width(from: context)
        let adjustedHeight = height(from: context)
        let yOffset = self.yOffset(from: context)
        
        switch (context.to, context.from) {
            case (.right, .root),
                 (.left, .root),
                 (.root,.top):  return CGRect(x: 0,
                                                y: yOffset,
                                                width: width,
                                                height: adjustedHeight)
            
            case (.root,.right): return CGRect(x: width,
                                               y: yOffset,
                                               width: width,
                                               height: adjustedHeight)
            
            case (.root,.left): return  CGRect(x: -width,
                                               y: yOffset,
                                               width: width,
                                               height: adjustedHeight)
            
            case (.bottom,.root),(.top,.root): return CGRect(x: 0,
                                             y: yOffset,
                                             width: width,
                                             height: adjustedHeight)
            
            case (.root,.bottom): return CGRect(x: 0,
                                                y: yOffset + adjustedHeight,
                                                width: width,
                                                height: adjustedHeight)
            
        default: fatalError()
        }
    }
    
    
    
    private func width(from context: Context) -> CGFloat {
         return context.contentSize.width
    }
    
    private func height(from context: Context) -> CGFloat {
        return context.contentSize.height * context.sizeOffsetMultiplier
    }
    
    private func yOffset(from context: Context) -> CGFloat {
        return context.contentSize.height - height(from: context)
    }
}
