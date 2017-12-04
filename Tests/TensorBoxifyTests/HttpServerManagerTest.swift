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
    var response : Int = 0 {
        didSet {
            
        }
    }
    
    static var allTests = [
        ("startServerSync", testStartServerSync),
        ("startServerAsync", testStartServerAsync)
        ]
    
    override func setUp() {
        super.setUp()
        let server = HttpServerManager.sharedManager
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
    typealias ResponseCompletion = (_ response: Int, _ string: String) -> Void
    
    class Helper {
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
                }
                else{
                    print("Error downloading data. Error = \(String(describing: error))")
                    completion(status, string)
                }
            })
            downloadTask.resume()
        }
    }
    
    func testStartServerAsync() {
        guard let url = URL(string: host + "/magic") else {
            XCTAssert(false, "URL not valid")
            return
        }
        Helper.pReq(url: url) { (status, string) in
            print("testStartServerAsync status: \(status) string: \(string)")
            XCTAssertTrue(status == 200)
            return
        }
    }
    
}
