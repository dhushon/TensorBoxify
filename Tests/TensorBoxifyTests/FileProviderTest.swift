//
//  FileProviderTest.swift
//  TensorBoxifyTests
//
//  Created by Dan Hushon on 12/6/17.
//

import Foundation
import XCTest
import FileProvider

let testLink = "https://drive.google.com/drive/folders/1YE6_zRetNZpiaEoYHDS_Rvc_msj1DA2A?usp=sharing"

@testable import TensorBoxify

class TensorBoxifyTests: XCTestCase {
    
    static var allTests = [
        ("testArguments", testArguments),
        ("testDirectoryGDrive", testDirectoryGDrive)
    ]
    
    var arguments : [String:String] = [:]
    var workingDir : String = ""
    
    override func setUp(){
        self.arguments = ProcessInfo.processInfo.environment
        debugPrint(arguments)
        workingDir = arguments["CWD"]
    }
    
    func testArguments() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let _ = arguments["HTTP_PATH"]
        print("Hello World")
    }

    func testDirectoryGDrive () {
    }
}

