//
//  FrameProviderTests.swift
//  AHSwipeViewControllerContainer_Tests
//
//  Created by Alex Hmelevski on 2018-02-02.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import AHSwipeViewControllerContainer

final class AHFameTester {

    var providerToTest =  AHFrameProvider()
    
    func test(expectedInitialFrame: CGRect ,
              expectedFinalFrame: CGRect,
              for context: Context,
              message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(expectedInitialFrame, providerToTest.initialFrame(forContext: context),"Initial Frame is not equal", file: file, line: line)
        XCTAssertEqual(expectedFinalFrame, providerToTest.finalFrame(forContext: context),"Final Frame is not equal", file: file, line: line)
    }
    
}

class FrameProviderTests: XCTestCase {
    let providerToTest = AHFrameProvider()
    let defaultSize = CGSize(width: 100, height: 100)
    let defaultMultiplier: CGFloat = 0.8
    var yOffset: CGFloat {
        return defaultSize.height - defaultSize.height * defaultMultiplier
    }
    var frameTester = AHFameTester()
    
    override func setUp() {
        frameTester = AHFameTester()
        frameTester.providerToTest = AHFrameProvider()
    }
    
    func test_frames_for_swipe_to_right_from_root(){
        let context = defaultContext(to: .right, from: .root)

        let expected = CGRect(x: defaultSize.width,
                                           y: yOffset ,
                                           width: defaultSize.width,
                                           height: defaultSize.height - yOffset)
        let expectedfinal = CGRect(x: 0,
                              y: yOffset ,
                              width: defaultSize.width,
                              height: defaultSize.height - yOffset)
        
        frameTester.test(expectedInitialFrame: expected, expectedFinalFrame: expectedfinal,for: context)
    }
    

    func test_final_frame_for_swipe_to_left_from_root(){
        let context = defaultContext(to: .left, from: .root)
        let expected = CGRect(x: -defaultSize.width,
                              y: yOffset ,
                              width: defaultSize.width,
                              height: defaultSize.height - yOffset)
        
        let expectedFinal = CGRect(x: 0 ,
                                   y: yOffset ,
                                   width: defaultSize.width,
                                   height: defaultSize.height - yOffset)
        
        frameTester.test(expectedInitialFrame: expected, expectedFinalFrame: expectedFinal, for: context)
    }
    
    
    func test_final_frame_for_swipe_to_bottom_from_root(){
        let context = defaultContext(to: .bottom, from: .root)
        let expected = CGRect(x: 0,
                              y: defaultSize.height ,
                              width: defaultSize.width,
                              height: defaultSize.height - yOffset)
        
        let expectedFinal = CGRect(x: 0,
                                   y: yOffset ,
                                   width: defaultSize.width,
                                   height: defaultSize.height - yOffset)
        
        frameTester.test(expectedInitialFrame: expected, expectedFinalFrame: expectedFinal,for: context)
    }
    
    func test_frames_for_swipe_to_top_from_root() {
        let context = defaultContext(to: .top, from: .root)
        let expected = CGRect(x: 0,
                              y: defaultSize.height ,
                              width: defaultSize.width,
                              height: defaultSize.height - yOffset)
        
        let expectedFinal = CGRect(x: 0,
                                   y: yOffset ,
                                   width: defaultSize.width,
                                   height: defaultSize.height - yOffset)
        
         frameTester.test(expectedInitialFrame: expected, expectedFinalFrame: expectedFinal,for: context)
    }
    
    
    private func defaultContext(to: ContainerState, from: ContainerState) -> Context {
        return Context(to: to,
                       from: from,
                       contentSize: defaultSize,
                       sizeOffsetMultiplier: defaultMultiplier)
    }
}
