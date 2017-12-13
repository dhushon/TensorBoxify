//
//  TBFiler.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/13/17.
//

import Foundation

typealias URLCompletionHandler = (_ response: Int, _ data: Data?) -> Void

protocol TBFiler {
    func fetch(url: URL) throws -> Data?
    func fetchAsync(url: URL, completion: @escaping URLCompletionHandler)
}
