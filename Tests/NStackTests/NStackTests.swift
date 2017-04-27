import XCTest
@testable import NStack

class NStackTests: XCTestCase {
    func test() {
        XCTAssertTrue(true)
    }


    static var allTests : [(String, (NStackTests) -> () throws -> Void)] {
        return [
            ("test", test),
        ]
    }
}
