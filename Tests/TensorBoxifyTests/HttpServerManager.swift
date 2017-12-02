//
//  HttpServerManager.swift
//  TensorBoxifyTests
//
//  Created by Dan Hushon on 12/2/17.
//

import Foundation
import Swifter

class HttpServerManager  {
    
    private static let sharedInstance = HttpServerManager()
    class var sharedManager : HttpServerManager {
        return sharedInstance
    }
    lazy let server = HttpServer()
    
    init() {
        server["/public/:path"] = shareFilesFromDirectory(publicDir)
        server["/files/:path"] = directoryBrowser("/")
        server["/magic"] = { .ok(.html("You asked for " + $0.path)) }
        server.start()
    }
    
    
}
