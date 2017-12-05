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
    
    let VOCJSONFile : String  = "{\n\"filename\" : \"lepage-170604-DGP-9916.jpg\",\n\"folder\" : \"images\",\n\"image_w_h\" : [4928,3280],\n\"objects\" : [\n{\n\"label\" : \"carconenumber-1\",\n\"x_y_w_h\" : [\n2287,\n1865,\n391,\n235\n]\n},\n{\n\"label\" : \"camera-camera\",\n\"x_y_w_h\" : [\n2304,\n788,\n377,\n322\n]\n},\n{\n\"label\" : \"car-bottom-front-1\",\n\"x_y_w_h\" : [\n570,\n770,\n3782,\n2347\n]\n}\n]\n}"
    
    let file = ["lepage-170604-DGP-9916"]
    let type = "json"
    var vocs : VOCElementSet? = nil
    
    static var allTests = [
        ("decodeVOCJSON", testJSONDecoder),
        ("encodeVOCJSON", testJSONEncoder)
    ]
    
    func testJSONDecoder() {
        let data = self.VOCJSONFile.data(using: String.Encoding.utf8)
        // parse json file identified
        let parser = LBVOCJSONParser()
        do {
            let _ = try parser.decode(data: data!)
            let voc: VOCElementSet? = parser.getParsed()
            XCTAssertNotNil(voc)
            self.vocs = voc
            let image = voc!.images[0]
            XCTAssertTrue(image.objects.count == 3)
        } catch {
            debugPrint("LBVOCJSONParser.decode", error)
        }
    }
    
    func testJSONEncoder() {
        testJSONDecoder()
        guard let voc : VOCElementSet = vocs else {
            XCTAssert(false, "VOC set cannot be nil for test")
            return
        }
        XCTAssertNoThrow({
            let parser = LBVOCJSONParser()
            let data = try parser.encode(voc: voc)
            //TODO:  test data
            debugPrint(String(data: data, encoding: String.Encoding.utf8))
        })
    }
    
    func getVOCElementSet() -> VOCElementSet? {
        return vocs
    }
}
