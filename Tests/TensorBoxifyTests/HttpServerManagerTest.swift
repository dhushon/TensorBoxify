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
    
    let host = "http://localhost:8080"
    
    static var allTests = [
        ("startServerSync", testStartServerSync),
        ("startServerAsync", testStartServerAsync)
        ]
    
    override func setUp() {
        super.setUp()
        let _ = HttpServerManager.sharedManager
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //test sync response
    func testStartServerSync() {
        let url = URL(string: "\(host)"+"/magic")
        XCTAssertNotNil(try String(contentsOf: url!))
    }
    
    func testStartServerAsync() {
        guard let url = URL(string: host + "/magic") else {
            XCTAssert(false, "URL not valid")
            return
        }
        HTTPHelper.pReq(url: url) { (status, string) in
            print("testStartServerAsync status: \(status) string: \(string)")
            XCTAssertTrue(status == 200)
            return
        }
    }
}

typealias ResponseCompletion = (_ response: Int, _ string: String) -> Void

class HTTPHelper {
    static func pReq(url : URL, completion: @escaping ResponseCompletion) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let request = URLRequest(url: url)
        var string = ""
        
        let downloadTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            let status = (response as! HTTPURLResponse).statusCode
            if(error == nil){
                string = String(describing: data)
                completion(status, string)
                return
            }
            else{
                print("Error downloading data. Error = \(String(describing: error))")
                completion(status, string)
                return
            }
        })
        downloadTask.resume()
    }
}
