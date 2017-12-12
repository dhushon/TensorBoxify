//
//  LocalFiler.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/6/17.
//

import Foundation
//import FilesProvider

@available(OSX 10.12, *)
class LocalFiler {
    var dirDictionary : [String:URL] = [:]
    let home = "HOME"
    let apps = "APPS"
    
    init() {
        let _ = getHomeDirectory() // preload default Directories
    }
    
    private func getHomeDirectory() -> URL? {
        if (dirDictionary[home] == nil) {
            dirDictionary.updateValue(FileManager.default.homeDirectoryForCurrentUser, forKey: home)
        }
        return dirDictionary[home]
    }
    
    public func getDirectory(key: String) -> URL? {
        if (key == home) {
            return getHomeDirectory()
        }
        return dirDictionary[key]
    }
    
    public func setNamedDirectory(key: String, dir: URL, createIfNotExists: Bool) throws {
        // Get Default FileManager
        let fileManager = FileManager.default
        let exists = (fileManager.fileExists(atPath: dir.absoluteString))
        // test directory progression and create on the way
        let host = dir.host
        dir.pathComponents.forEach { component in
            let exists = fileManager.fileExists(atPath: component)
            
        }
        debugPrint(exists)
    }
    
    func urlForDataStorage(filename: String?) -> URL? {
        if (dirDictionary[apps] == nil)  {
            // Get Default FileManager
            let fileManager = FileManager.default
            
            // 2
            guard let folder = fileManager.urls(for: .applicationSupportDirectory,
                                                in: .userDomainMask).first else {
                                                    return nil
            }
            
            // 3
            let appFolder = folder.appendingPathComponent("TensorBoxify")
            var isDirectory: ObjCBool = false
            let folderExists = fileManager.fileExists(atPath: appFolder.path,
                                                      isDirectory: &isDirectory)
            if !folderExists || !isDirectory.boolValue {
                do {
                    // 4
                    try fileManager.createDirectory(at: appFolder,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    return nil
                }
            }
            dirDictionary.updateValue(appFolder, forKey: apps)
            
            if (filename != nil) {
                let dataFileUrl = appFolder.appendingPathComponent(filename!)
                return dataFileUrl
            }
        }
        return dirDictionary[apps]
    }
}

