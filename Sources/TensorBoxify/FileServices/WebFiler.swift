//
//  WebFiler.swift
//  TensorBoxifyPackageDescription
//
//  Created by Dan Hushon on 12/11/17.
//

import Foundation

public extension Data {
    var fileExtension: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)
        
        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = ".jpg"
        case 0x89:
            ext = ".png"
        case 0x47:
            ext = ".gif"
        case 0x49, 0x4D :
            ext = ".tiff"
        default:
            ext = ".png"
        }
        return ext
    }
}

class WebFiler : TBFiler {
    
    public func fetch(url: URL) -> Data? {
        var idata : Data?
        WebFiler.fetchAsync(url: url) { response, data in
            print("tried to fetch: \(url.absoluteString) response: \(response)\n")
            print("data")
            idata = data
        }
        return idata
    }
    
    public static func fetchAsync(url: URL, completion: @escaping URLCompletionHandler) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let request = URLRequest(url: url)
    
        let downloadTask = session.dataTask(with: request) { data, response, error in
            let status = (response as! HTTPURLResponse).statusCode
            if(error == nil){
                completion(status, data)
                print(data!.fileExtension)
                return
            } else{
                print("Error downloading data. Error = \(String(describing: error))")
                completion(status, data)
                return
            }
        }
        downloadTask.resume()
    }
}
