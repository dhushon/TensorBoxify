//
//  FileProviderTest.swift
//  TensorBoxifyTests
//
//  Created by Dan Hushon on 12/6/17.
//

import Foundation
import XCTest

//import FileProvider

// this file is stored in Azure Blob Storage account.
let testLink = "https://vdatacloudmedia.blob.core.windows.net/vdatacloud/TensorBox/images/lepage-170604-DGP-9916.jpg"

@testable import TensorBoxify
class FileProviderTests: XCTestCase {
    
    static var allTests = [
        ("testArguments", testArguments),
        ("testLocalFiler", testLocalFiler),
        ("testWebFile", testWebFiler)
    ]
    
    var arguments : [String:String] = [:]
    var workingDir : String?
    
    override func setUp(){
        self.arguments = ProcessInfo.processInfo.environment
    }
    
    func testLocalFiler() {
        if #available(OSX 10.12, *) {
            let filer = LocalFiler()
            let testURL = URL(fileURLWithPath: "file:///tmp/any")
            do {
                try filer.setNamedDirectory(key: "test", dir: testURL, createIfNotExists: true)
            } catch {
                debugPrint(error)
            }
            //let url = filer.urlForDataStorage()
            //debugPrint(url!)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func testArguments() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let test = arguments["HOME"]
        print("Arguments.HOME=\(String(describing: test))")
    }
    
    func contentTypeForImage(_ data: Data) -> String? {
        if (data.count > 0) {
            var values = [UInt8](repeating:0, count:1)
            data.copyBytes(to: &values, count: 1)
            switch (values[0]) {
            case 0xff:
                return "image/jpeg"
            case 0x89:
                return "image/png"
            case 0x47:
                return "image/gif"
            case 0x49, 0x4D:
                return "image/tiff"
            default:
                break
            }
        }
        return nil
    }
    
    func testWebFiler() {
        guard let url = URL(string: testLink) else {
            XCTAssert(false, "URL not valid")
            return
        }
        let expect = expectation(description: "Testing web load of url \(url.absoluteString) - ")
        WebFiler.fetchWebFileAsync(url: url) { response, data in
            XCTAssertNotNil(data!)
            let string: String? = self.contentTypeForImage(data!)
            XCTAssertTrue(string == "image/jpeg")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 8) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimout errored: \(error)")
            }
        }
    }
}

