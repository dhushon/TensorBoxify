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
    
    enum ServerState {
        case started
        case stopped
    }
    lazy private var serverState = ServerState.stopped
    
    lazy var server = HttpServer()
    var publicDir: String = "/tmp" {
        didSet {
            server["/public/:path"] = shareFilesFromDirectory(publicDir)
            // TODO: determine if the publicDir setting requires a restart
            startServer() // restart the web server given the new details
        }
    }
    
    func startServer() {
        do {
            stopServer()
            try server.start()
            serverState = ServerState.started
        } catch {
            debugPrint("HTTPServerManager:",error)
        }
    }
    
    func stopServer() {
        if (serverState == ServerState.started) {
            server.stop()
            serverState = ServerState.stopped
        }
    }
    
    private init() {
        server["/public/:path"] = shareFilesFromDirectory(publicDir)
        server["/files/:path"] = directoryBrowser("/")
        server["/magic"] = { .ok(.html("You asked for " + $0.path)) }
        startServer()
    }
    
}
