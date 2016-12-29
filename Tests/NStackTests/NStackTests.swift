import XCTest
@testable import NStackTests

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
