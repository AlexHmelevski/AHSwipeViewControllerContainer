//
//  PercentCalculatorTests.swift
//  AHSwipeViewControllerContainer_Tests
//
//  Created by Alex Hmelevski on 2018-02-02.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import AHSwipeViewControllerContainer

final class AHPercentCalculatorTester {
    
    private let  calculator = AHPercentCalculator()
    
    func testPercentage(expected: CGFloat ,
                        for context: PercentCalculatorContext,
                        message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(expected, calculator.percent(for: context),"Wrong percentage for \(context.direction)", file: file, line: line)
    }
    
}

class PercentCalculatorTests: XCTestCase {
    
    
    var tester: AHPercentCalculatorTester!
    var contextFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
    
    override func setUp() {
        tester = AHPercentCalculatorTester()
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    func test_swipe_right_starting_point_zero_current_positive() {
       let context = defaultContext(direction: .right, currentPoint: CGPoint(x: 50, y: 0))
       tester.testPercentage(expected: 0.5, for: context)
    }
    
    func test_swipe_righ_starting_point_in_the_middle_curret_negative() {
        let context = defaultContext(direction: .right, currentPoint: CGPoint(x: 0, y: 0), startPoint: CGPoint(x: 50, y: 0))
        tester.testPercentage(expected: -0.5, for: context)
    }
    
    
    func test_swipe_left_starting_point_right_edge_current_positive() {
        let context = defaultContext(direction: .left, currentPoint: CGPoint(x: 50, y: 0), startPoint: CGPoint(x: 100, y: 0))
        tester.testPercentage(expected: 0.5, for: context)
    }
    func test_swipe_left_starting_point_in_the_middle_curret_positive() {
        let context = defaultContext(direction: .left, currentPoint: CGPoint(x: 0, y: 0), startPoint: CGPoint(x: 50, y: 0))
        tester.testPercentage(expected: 0.5, for: context)
    }
    
    func test_swipe_left_starting_point_in_the_middle_curret_negative() {
        let context = defaultContext(direction: .left, currentPoint: CGPoint(x: 100, y: 0), startPoint: CGPoint(x: 50, y: 0))
        tester.testPercentage(expected: -0.5, for: context)
    }
    
    
    func test_swipe_up_starting_point_bottom_edge_current_positive() {
          let context = defaultContext(direction: .up, currentPoint: CGPoint(x: 0, y: 50), startPoint: CGPoint(x: 0, y: 100))
        tester.testPercentage(expected: 0.5, for: context)
    }
    
    func test_swipe_up_starting_point_in_the_middle_curret_negative() {
        let context = defaultContext(direction: .up, currentPoint: CGPoint(x: 0, y: 100), startPoint: CGPoint(x: 0, y: 50))
        tester.testPercentage(expected: -0.5, for: context)
    }
    
    func test_swipe_down_starting_point_zero_current_positive() {
        let context = defaultContext(direction: .down, currentPoint: CGPoint(x: 0, y: 50))
        tester.testPercentage(expected: 0.5, for: context)
    }
    
    func test_swipe_down_starting_point_in_the_middle_curret_negative() {
        let context = defaultContext(direction: .down, currentPoint: CGPoint(x: 0, y: 0), startPoint: CGPoint(x: 0, y: 50))
        tester.testPercentage(expected: -0.5, for: context)
    }
    
    
    private func defaultContext(direction: Direction, currentPoint: CGPoint = .zero, startPoint: CGPoint = .zero) -> PercentCalculatorContext{
        return PercentCalculatorContext(direction: direction, currentPoint: currentPoint, startPoint: startPoint, contextFrame: contextFrame)
    }
}
