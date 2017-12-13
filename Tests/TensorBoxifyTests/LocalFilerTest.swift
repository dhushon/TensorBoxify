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
        ("testNamedDirectory", testNamedDirectory),
        ("testAppDirectory", testAppDirectory)]

    func testNamedDirectory() {
        let filer = LocalFiler()
        // make sure we start with an empty directory
        XCTAssertNotNil(filer.getDirectory(key: "HOME"),"couldn't get the $HOME directory")
        // try to set a new directory
        let test: URL = URL(fileURLWithPath: "/tmp/any")
        XCTAssertNoThrow(try filer.setNamedDirectory(key: "TMPANY", dir: test, createIfNotExists: true),"could not create a directory")
        XCTAssertEqual(test, filer.getDirectory(key: "TMPANY"),"directory did not get added to dictionary")
        //now clean up
        XCTAssertThrowsError(try FileManager.default.removeItem(at: test), "LocalFilerTests.testNamedDirectory: could not remove directory")
    }
    
    func testAppDirectory() {
        let filer = LocalFiler()
        let url = filer.urlForAppStorage(filename: "test.txt")
        XCTAssertNotNil(url, "LocalFilerTests.testAppDirectory: could not get urlForAppStorage")
        XCTAssertNotNil(filer.getDirectory(key: "APPS"), "LocalFilerTests.testAppDirectory: could not getDirectory for name")
        // now clean up
        XCTAssertThrowsError(try FileManager.default.removeItem(at: filer.getDirectory(key: "APPS")!), "LocalFilerTests.testAppDirectory: could not remove directory")
    }
}

