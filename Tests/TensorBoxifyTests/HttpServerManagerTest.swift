//
//  HttpServerManagerTests.swift
//  TensorBoxifyPackageDescription
//
//  Created by Dan Hushon on 12/4/17.
//

import Foundation
import XCTest
import Swifter

class HttpServerManagerTests: XCTestCase {
    
    static var allTests = [
        ("startServer", testStartServer),
        ]
    
    override func setUp() {
        super.setUp()
        let server = HttpServerManager.sharedManager
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStartServer() {
        let url = URL(string: "http://localhost:8080/magic")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            print("webresponse:+\((response as! HTTPURLResponse).statusCode)")
            guard let data = data, error == nil else {
                XCTAssert(false, "failed to retrieve basic web directory from localhost -> firewall blocking?")
                return }
            print(String(data: data, encoding: String.Encoding.utf8)!)
        }
        task.resume()
    }
    
}
