//
//  WebFilerTests.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/13/17.
//

import Foundation
import XCTest
@testable import TensorBoxify

let testLink = "https://vdatacloudmedia.blob.core.windows.net/vdatacloud/TensorBox/images/lepage-170604-DGP-9916.jpg"

extension Data {
    // determine if the read data is of image type and which
    func contentTypeForImage() -> String? {
        if (self.count > 0) {
            var values = [UInt8](repeating:0, count:1)
            self.copyBytes(to: &values, count: 1)
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
}

class WebFilerTests : XCTestCase {
    
    static var allTests = [
        ("testWebFiler", testWebFiler)
    ]
    
    func testWebFiler() {
        guard let url = URL(string: testLink) else {
            XCTAssert(false, "URL not valid")
            return
        }
        let expect = expectation(description: "Testing web load of url \(url.absoluteString) - ")
        WebFiler.fetchAsync(url: url) { response, data in
            XCTAssertNotNil(data!)
            let string: String? = data!.contentTypeForImage()
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
