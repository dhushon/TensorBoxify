//
//  TensorBoxParserTest.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation
import XCTest

@testable import TensorBoxify

class TensorBoxParserTest: XCTestCase {
    
    let file1 = ["TensorBoxTest"]
    let file2 = ["TensorBoxTestv2"]
    let vocfile = ["lepage-170604-DGP-9916"]
    let type = "json"
    var tbElementSet: TensorBoxElementSet? = nil
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTensorBoxDecoderv2() {
        // get url (check that bundle includes necessary JSON)
        let jsonURL = Resource(name: file2[0], type: type).url
        try XCTAssertTrue((jsonURL.checkResourceIsReachable()))
        print("JSONURL: \(String(describing: jsonURL)) is reachable")
        
        // parse json file identified
        do {
            let tbp = try TensorBoxParser(url: jsonURL)
            XCTAssertTrue(tbp?.tensorBoxElementSet?.images.count == 2)
            print("ok")
        } catch {
            print("Caught init? exception: \(error)")
            XCTAssertTrue(false)
        }
    }
    
    func testTensorBoxDecoderv1() {
        // get url (check that bundle includes necessary JSON)
        let jsonURL = Resource(name: file1[0], type: type).url
        try XCTAssertTrue((jsonURL.checkResourceIsReachable()))
        print("JSONURL: \(String(describing: jsonURL)) is reachable")
        
        // parse json file identified
        do {
            let tbp = try TensorBoxParser(url: jsonURL)
            XCTAssertTrue(tbp?.tensorBoxElementSet?.images.count == 2)
            self.tbElementSet = tbp?.tensorBoxElementSet
        } catch {
            print("Caught init? exception: \(error)")
            XCTAssertTrue(false)
        }
        print("JSONParse: successfully parsed objects")
    }
    
    func testTensorBoxEncoder() {
        let jsonURL = Resource(name: file2[0], type: type).url
        print("encoded to: \(jsonURL)")
        //get the Structure to encode:
        do {
            let tbp = try TensorBoxParser(url: jsonURL)
            XCTAssertTrue(tbp?.tensorBoxElementSet?.images.count == 2)
            do {
                //now do the encode
                let tbset = tbp?.tensorBoxElementSet
                print("here")
                let jsonoutURL = Resource(name: String(file2[0]+"tbenc"), type: type).url
                try tbp?.encode(url: jsonoutURL, tbes: tbset)
                // check to see that the document was produced
                XCTAssertTrue(true)
                print("JSONParser.encoder successfully encoded objects")
            } catch {
                XCTAssertTrue(false, "Couldn't encode the json: \(error)")
                return
            }
        } catch {
            XCTAssertTrue(false, "Couldn't produce the structure to encode")
            return
        }
    }
    
    func testVOCEncoder() {
        // get a VOCElementSet from other test routine
        let vocjsonParser = LBVOCJSONParserTest()
        vocjsonParser.testJSONDecoder()
        guard let voca = try vocjsonParser.getVOCElementSet() else {
            XCTAssertTrue(false, "TensorBoxDecoderTest.testVOCEncoder(): couldn't get a VOCElementSet Reference")
            return
        }
        let jsonURL = Resource(name: file2[0]+"venc", type: type).url
        print("encoded to: \(jsonURL)")
        do {
            let tbp = try TensorBoxParser() // just use the decoder - so use the default initializer
            try tbp.encode(url: jsonURL, voc: voca)
            print("completed encoding")
        } catch {
            print("TensorBoxDecoderTest.testVOCEncoder: failed - \(error)")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func getTBElementSet() -> TensorBoxElementSet? {
        return tbElementSet
    }
    
}
