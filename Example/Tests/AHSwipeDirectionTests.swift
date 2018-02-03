import UIKit
import XCTest
@testable import AHSwipeViewControllerContainer

class Tests: XCTestCase {
    
   
    
    func test_returns_right_direction() {
        let point = CGPoint(x: 1, y: 0)
        let direction = Direction(velocity: point)
        XCTAssertEqual(direction, .right)
    }
    
    
    func test_returns_left_direction() {
        let point = CGPoint(x: -1, y: 0)
        let direction = Direction(velocity: point)
        XCTAssertEqual(direction, .left)
    }
    
    func test_returns_down_direction() {
        let point = CGPoint(x: 0, y: 1)
        let direction = Direction(velocity: point)
        XCTAssertEqual(direction, .down)
    }
    
    
    func test_returns_up_direction() {
        let point = CGPoint(x: 0, y: -1)
        let direction = Direction(velocity: point)
        XCTAssertEqual(direction, .up)
    }
}
