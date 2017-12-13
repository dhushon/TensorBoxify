//
//  FileProviderTest.swift
//  TensorBoxifyTests
//
//  Created by Dan Hushon on 12/6/17.
//

import Foundation
import XCTest
//import FileProvider
@testable import TensorBoxify

    
class FileProviderTests: XCTestCase {
    
    static var allTests = [
        ("testArguments", testArguments)
    ]
    
    var arguments : [String:String] = [:]
    var workingDir : String?
    
    override func setUp(){
        self.arguments = ProcessInfo.processInfo.environment
    }
    
    func testArguments() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let test = arguments["HOME"]
        print("Arguments.HOME=\(String(describing: test))")
    }
}

