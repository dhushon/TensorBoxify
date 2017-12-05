import XCTest
@testable import TensorBoxify

class TensorBoxifyTests: XCTestCase {
    
    var arguments : [String:String] = [:]
    
    override func setUp(){
        self.arguments = ProcessInfo.processInfo.environment
        debugPrint(arguments)
    }
    
    func testArguments() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let _ = arguments["HTTP_PATH"]
        print("Hello World")
        
    }


    static var allTests = [
        ("testArguments", testArguments),
    ]
    
}
