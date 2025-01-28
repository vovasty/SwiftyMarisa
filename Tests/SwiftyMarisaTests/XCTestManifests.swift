import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(SwiftyMarisaTests.allTests),
        ]
    }
#endif
