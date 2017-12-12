//
//  LocalFilerTest.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/12/17.
//

import Foundation
import XCTest

@testable import TensorBoxify
@available(OSX 10.12, *)
class LocalFilerTests: XCTestCase {
    
    static var allTests = [
        ("testNamedDirectory", testNamedDirectory)]

    func testNamedDirectory() {
        let filer = LocalFiler()
        // make sure we start with an empty directory
        XCTAssertNotNil(filer.getDirectory(key: "HOME"),"couldn't get the $HOME directory")
        // try to set a new directory
        let test: URL = URL(fileURLWithPath: "file:///private/tmp/plus")
        XCTAssertNoThrow(try filer.setNamedDirectory(key: "TMPPLUS", dir: test, createIfNotExists: true),"could not create a directory")
        XCTAssertEqual(test, filer.getDirectory(key: "TMPPLUS"),"directory did not get added to dictionary")
    }
}

