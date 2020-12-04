import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(tic_tac_toeTests.allTests),
    ]
}
#endif
