//
//  Resource.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

class Resource {
    
    static var resourcePath = "./Resources"
    
    let name: String
    let type: String
    let prefix = "images/"
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    var path: String {
        guard let path: String = Bundle(for: Swift.type(of: self)).path(forResource: name, ofType: type) else {
            let filename: String = type.isEmpty ? name : "\(name).\(type)"
            return "\(Resource.resourcePath)/\(filename)"
        }
        return path
    }
    
    var url: URL {
        //let currentBundle = Bundle.allBundles.filter() { $0.bundlePath.hasSuffix(".xctest") }.first!
        //let realBundle = Bundle(path: "\(currentBundle.bundlePath)/../../../../Tests/MyProjectTests/Resources")
        let any = Bundle(for: Swift.type(of: self))
        let path = any.bundlePath
        let url: URL? = Bundle(for: Swift.type(of: self)).url(forResource: (prefix+name), withExtension: type)
        if (url != nil) {
            return url!
        } else {
            let filename: String = (type.isEmpty ? name : "\(name).\(type)")
            return URL(string: "file:///\(Resource.resourcePath)/\(filename)")!
        }
    }
    
    var content: String? {
        return try? String(contentsOfFile: path).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var base64EncodedData: Data? {
        guard let string = content, let data = Data(base64Encoded: string) else {
            return nil
        }
        return data
    }
    
}
