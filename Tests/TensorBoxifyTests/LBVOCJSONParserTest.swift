//
//  LBVOCJSONParserTest.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

import XCTest

@testable import TensorBoxify

class LBVOCJSONParserTest: XCTestCase {
    
    let path = [""]
    let file = ["lepage-170604-DGP-9916"]
    let type = "json"
    var vocs : VOCElementSet? = nil
    
    static var allTests = [
        ("decodeVOCJSON", testJSONDecoder),
        ("encodeVOCJSON", testJSONEncoder)
    ]
    
    func testJSONDecoder() {
        // get url (check that bundle includes necessary JSON)
        let jsonURL = Resource(name: file[0], type: type).url
        try XCTAssertTrue((jsonURL.checkResourceIsReachable()))
        print("JSONURL: \(String(describing: jsonURL)) is reachable")
        
        // parse json file identified
        let parser = LBVOCJSONParser()
        XCTAssertNoThrow({
            let _ = try parser.decode(url: jsonURL)
            let voc: VOCElementSet? = parser.getParsed()
            XCTAssertNotNil(voc)
            self.vocs = voc
            let image = voc!.images[0]
            XCTAssertTrue(image.objects.count == 3)
        })
    }
    
    func testJSONEncoder() {
        testJSONDecoder()
        let jsonURL = Resource(name: file[0], type: type).url
        guard let voc : VOCElementSet = vocs else {
            XCTAssert(false, "VOC set cannot be nil for test")
            return
        }
        XCTAssertNoThrow({
            let parser = LBVOCJSONParser()
            try parser.encode(url: jsonURL,voc: voc)
        })
    }
    
    func getVOCElementSet() -> VOCElementSet? {
        return vocs
    }
}
