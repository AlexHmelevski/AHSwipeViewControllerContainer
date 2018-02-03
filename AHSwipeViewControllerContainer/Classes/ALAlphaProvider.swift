//
//  ALAlphaProvider.swift
//  AHSwipeViewControllerContainer
//
//  Created by Alex Hmelevski on 2018-02-02.
//

import Foundation

public protocol AlphaProvider {
    func initialAlpha(forContext context: Context) -> CGFloat
    func finalAlpha(forContext context: Context) -> CGFloat
}

public final class AHAlphaProvider: AlphaProvider {
    
    public init() {}
    public func initialAlpha(forContext context: Context) -> CGFloat {
        switch (context.to, context.from) {
            case (.top, .root): return 0.0
        default: return 1.0
            
        }
    }
    
    public func finalAlpha(forContext context: Context) -> CGFloat {
        switch (context.to, context.from) {
        case (.root,.top): return 0.0
        default: return 1.0
            
        }
    }
    
    
}
