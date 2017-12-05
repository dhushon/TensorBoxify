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
    
    let TBJSONv1File : String = "[\n{\n\"image_path\": \"images/lepage-170604-DGP-9916.jpg\",\n\"rects\":\n[\n{\"x1\": 2287, \"y1\": 1865, \"x2\": 2677, \"y2\": 2099},\n{\"x1\": 2304, \"y1\": 788, \"x2\": 2680, \"y2\": 1109}\n]\n},\n{\n\"image_path\": \"images/lepage-17604-DGP-9916.jpg\",\n\"rects\":\n[{\"x1\": 570, \"y1\": 770, \"x2\": 4351, \"y2\": 3116}]\n}\n]"
    let TBJSONv2File : String = "{\"images\":[\n{\n\"id\": 12345,\n\"image_path\": \"images/lepage-170604-DGP-9916.jpg\",\n\"rects\":\n[\n{\"classID\": 123, \"x1\": 2287, \"y1\": 1865, \"x2\": 2677, \"y2\": 2099 },\n{\"classID\": 124, \"x1\": 2304, \"y1\": 788, \"x2\": 2680, \"y2\": 1109 }\n]\n},\n{\n\"id\": 12346,\n\"image_path\": \"images/lepage-17604-DGP-9916.jpg\",\n\"rects\":\n[ {\"classID\": 123, \"x1\": 570, \"y1\": 770, \"x2\": 4351, \"y2\": 3116} ]\n}]\n}"
    
    let file1 = ["TensorBoxTest"]
    let file2 = ["TensorBoxTestv2"]
    let vocfile = ["lepage-170604-DGP-9916"]
    let type = "json"
    var tbElementSet: TensorBoxElementSet? = nil
    
    static var allTests = [
        ("decodeTBJSONv1", testTensorBoxDecoderv1),
        ("decodeTBJSONv2", testTensorBoxDecoderv2),
        ("encodeTBJSON", testTensorBoxEncoder),
        ("encodeTB2VOCJSON", testVOCEncoder)
    ]
    
    func testTensorBoxDecoderv2() {
        let data = self.TBJSONv2File.data(using: String.Encoding.utf8)
        // parse json file identified
        do {
            let tbp = try TensorBoxParser(data: data!)
            XCTAssertTrue(tbp?.tensorBoxElementSet?.images.count == 2)
            debugPrint(tbp?.tensorBoxElementSet?.images)
        } catch {
            print("Caught init? exception: \(error)")
            XCTAssertTrue(false)
        }
    }
    
    func testTensorBoxDecoderv1() {
        let data = self.TBJSONv1File.data(using: String.Encoding.utf8)
        // parse json file identified
        do {
            let tbp = try TensorBoxParser(data: data!)
            XCTAssertTrue(tbp?.tensorBoxElementSet?.images.count == 2)
            self.tbElementSet = tbp?.tensorBoxElementSet
        } catch {
            print("Caught init? exception: \(error)")
            XCTAssertTrue(false)
        }
        print("JSONParse: successfully parsed objects")
    }
    
    func testTensorBoxEncoder() {
        let data = self.TBJSONv2File.data(using: String.Encoding.utf8)
        do {
            let tbp = try TensorBoxParser(data: data!)
            XCTAssertTrue(tbp?.tensorBoxElementSet?.images.count == 2)
            do {
                //now do the encode
                guard let tbset = tbp?.tensorBoxElementSet else {
                    XCTAssertTrue(false, "Could not parse TBv2 into a TensorBox Structure")
                    return
                }
                let data = try tbp?.encode(tbes: tbset)
                debugPrint(String(data: data!, encoding: String.Encoding.utf8))
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
        guard let voca = vocjsonParser.getVOCElementSet() else {
            XCTAssertTrue(false, "TensorBoxDecoderTest.testVOCEncoder(): couldn't get a VOCElementSet Reference")
            return
        }
        XCTAssertNoThrow({
            let tbp = TensorBoxParser() // just use the decoder - so use the default initializer
            let data = try tbp.encode(voc: voca)
            debugPrint(String(data: data, encoding: String.Encoding.utf8))
        })
    }
    
    func getTBElementSet() -> TensorBoxElementSet? {
        return tbElementSet
    }
    
}
