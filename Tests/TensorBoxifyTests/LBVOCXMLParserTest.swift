//
//  LBVOCXMLParserTest.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation
import XCTest

@testable import TensorBoxify

class LBVOCXMLDecoderTest: XCTestCase {
    
    let file = ["lepage-170604-DGP-9916"]
    let type = "xml"
    
    let VOCXMLFile : String = "<annotation>\n<folder>images</folder>\n<filename>lepage-170604-DGP-9916.jpg</filename>\n<size>\n<width>4928</width>\n<height>3280</height>\n</size>\n<segmented>0</segmented>\n<object>\n<name>carconenumber-1</name>\n<bndbox>\n<xmin>2287</xmin>\n<ymin>1865</ymin>\n<xmax>2677</xmax>\n<ymax>2099</ymax>\n</bndbox>\n</object>\n<object>\n<name>camera-camera</name>\n<bndbox>\n<xmin>2304</xmin>\n<ymin>788</ymin>\n<xmax>2680</xmax>\n<ymax>1109</ymax>\n</bndbox>\n</object>\n<object>\n<name>car-bottom-front-1</name>\n<bndbox>\n<xmin>570</xmin>\n<ymin>770</ymin>\n<xmax>4351</xmax>\n<ymax>3116</ymax>\n</bndbox>\n</object>\n</annotation>"
    
    static var allTests = [
        ("decodeVOCXML", testXMLDecoder)
    ]
    
    func testXMLDecoder() {
        let data = self.VOCXMLFile.data(using: String.Encoding.utf8)
        XCTAssertNoThrow({
            let parser = LBVOCXMLParser()
            try parser.decode(data: data!)
            let voc: VOCElementSet? = parser.getParsed()
            XCTAssertNotNil(voc)
            let image = voc!.images[0]
            XCTAssertTrue(image.objects.count == 3)
        },"XMLDecoder threw error")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
