// MyMath/Tests/MyMathTests/MyMathTests.swift

import XCTest
@testable import MyMath

final class MyMathTests: XCTestCase {
    func testAdd() {
        XCTAssertEqual(MyMath.add(2, 3), 5)
    }
    
    func testSubtract() {
        XCTAssertEqual(MyMath.subtract(5, 2), 3)
    }
    
    func testMultiply() {
        XCTAssertEqual(MyMath.multiply(4, 5), 20)
    }
    
    func testDivide() {
        XCTAssertEqual(MyMath.divide(10, 2), 5)
        XCTAssertNil(MyMath.divide(10, 0))
    }
}
