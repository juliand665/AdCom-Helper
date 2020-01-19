import XCTest
@testable import AdComData

final class AdComDataTests: XCTestCase {
    static let allTests = [
        ("testExample", testExample),
    ]
	
    func testExample() {
		// just testing building & linking, lol
		_ = Client(playerID: "invalid").getUserData()
    }
}
