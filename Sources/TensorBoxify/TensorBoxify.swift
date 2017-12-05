//
//  TensorBoxify.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

public final class TensorBoxify {
    private let arguments: [String]
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws {
        print("Hello TensorBoxify - arguments loading")
        guard arguments.count > 1 else {
            throw Error.missingResourceDirectory
        }
        // The first argument is the execution path
        let _ = arguments[1]
    }
}

public extension TensorBoxify {
    enum Error: Swift.Error {
        case missingResourceDirectory
        case failedToCreateFile
    }
}


