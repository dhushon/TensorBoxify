//
//  TensorBoxParser.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

/* tensorbox annotation format:
 https://github.com/Russell91/TensorBox/blob/master/utils/annolist/readme.md
 //v2
 {
 "images": [image],
 "classes": [string]
 }
 
 image{
 "id": int,
 "image_path": string,
 "rects": [rect]
 }
 
 rect{
 "classID": int,
 "x1": int,
 "y1": int,
 "x2": int,
 "x2": int
 }*/

// trying native decoding http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/
enum TBVersions: String {
    case v1 = "1"
    case v2 = "2"
}

// some JSON structures are versioned, support differential encoding based upon versioned schema
struct TensorBoxRect: Codable {
    static var version: Int = 1
    let classID: Int //v2
    let xmin: Int
    let ymin: Int
    let xmax: Int
    let ymax: Int
    
    enum CodingKeys: String, CodingKey {
        case xmin = "x1"
        case xmax = "x2"
        case ymin = "y1"
        case ymax = "y2"
    }
    
    enum CodingKeysv2: String, CodingKey {
        case classID = "classID" //v2
        case xmin = "x1"
        case xmax = "x2"
        case ymin = "y1"
        case ymax = "y2"
    }
}

public struct TensorBoxElement: Codable {
    static var version: Int = 1
    
    let id: Int //v2
    let imagePath: String
    let rects: [TensorBoxRect]
    
    enum CodingKeys: String, CodingKey {
        case imagePath = "image_path"
        case rects = "rects"
    }
    
    enum CodingKeysv2: String, CodingKey {
        case id = "id"
        case imagePath = "image_path"
        case rects = "rects"
        
    }
}

public struct TensorBoxElementSet: Codable {
    static var version: Int = 1
    
    let images : [TensorBoxElement] //v2
    //let classes : [String] //v2
    
    enum CodingKeys: String, CodingKey {
        case images = "images" //v2
        //case classes = "classes" //v2
    }
    
    init?(tb: [TensorBoxElement]) {
        self.images = tb
    }
}

extension TensorBoxElement {
    public init(from decoder: Decoder) throws {
        var flag = (decoder.versionContext?.responseType)
        if (flag == nil) {
            flag = TBVersions.v2.rawValue
        }
        var id = -1 // for v1 structure id is -1
        let container = try decoder.container(keyedBy: CodingKeysv2.self)
        let imagePath = try container.decodeIfPresent(String.self, forKey: .imagePath)
        let rects = try container.decodeIfPresent([TensorBoxRect].self, forKey: .rects)
        //id is a v2 requirement
        let identity = try container.decodeIfPresent(Int.self, forKey: .id)
        if (identity != nil) {
            id = identity!
        }
        self.init(id: id, imagePath: imagePath!, rects: rects!)
    }
}

extension TensorBoxRect {
    public init(from decoder: Decoder) throws {
        var flag = (decoder.versionContext?.responseType)
        if (flag == nil) {
            flag = TBVersions.v2.rawValue
        }
        var classID: Int = -1 // for v1 structure classID is -1
        let container = try decoder.container(keyedBy: CodingKeysv2.self)
        let xmin = try container.decodeIfPresent(Int.self, forKey: .xmin)
        let ymin = try container.decodeIfPresent(Int.self, forKey: .ymin)
        let xmax = try container.decodeIfPresent(Int.self, forKey: .xmax)
        let ymax = try container.decodeIfPresent(Int.self, forKey: .ymax)
        //classID is a v2 construct
        let cID = try container.decodeIfPresent(Int.self, forKey: .classID)
        if (cID != nil) {
            classID = cID!
        }
        self.init(classID: classID, xmin: xmin!, ymin: ymin!, xmax: xmax!, ymax: ymax!)
    }
}

public class TensorBoxParser: VOCParser {
    
    var version = 0
    public var tensorBoxElementSet: TensorBoxElementSet? = nil
    
    init() {
        // default initializer
    }
    
    init?(url: URL) throws {
        _ = try decode(url: url)
    }
    
    func decode(url: URL) throws {
        if url.isFileURL {
            do {
                let data = try Data(contentsOf: url, options: .alwaysMapped)
                let decoder = JSONDecoder(context: VersionContext(responseType: TBVersions.v1.rawValue))
                do {
                    //try decodev1
                    let tensorBoxArray: [TensorBoxElement] = try decoder.decode([TensorBoxElement].self, from: data)
                    let tensorBoxElementSet = TensorBoxElementSet(tb: tensorBoxArray)
                    self.tensorBoxElementSet = tensorBoxElementSet
                    print(String(describing:(tensorBoxElementSet)))
                    return
                } catch {
                    debugPrint("Maybe not a v1 file trying v2?", error )
                    // but don't throw until after we have tested next version
                }
                // try decode v2
                do {
                    // reset the decoder to use the version 2 Context Keys and strategies
                    decoder.set(context: VersionContext(responseType: TBVersions.v2.rawValue))
                    let tensorBoxElementSet = try decoder.decode(TensorBoxElementSet.self, from: data)
                    self.tensorBoxElementSet = tensorBoxElementSet
                    print(String(describing:(tensorBoxElementSet)))
                    return
                } catch {
                    debugPrint("Couldn't decode file using v1 or v2:", error)
                    throw VOCParserError.decodeError(desc: "Could not decode file: \(error)")
                }
            } catch {
                print("Could not read file: \(error)")
                throw VOCParserError.fileError(desc: "Could not read / mapped file: \(error)")
            }
        } else {
            throw VOCParserError.fileError(desc: "either malcoded URL or missing file: \(url)")
        }
    }
    
    func translate(voc: VOCElementSet?) -> TensorBoxElementSet? {
        var tbes: [TensorBoxElement] = []
        voc?.images.forEach { image in
            let id: Int = Int(arc4random_uniform(32784))
            let imagePath: String = concatFilename(folder: image.folder, file: image.filename)
            var rects: [TensorBoxRect] = []
            image.objects.forEach { object in
                // let's use classID = -1 for unknown -> don't know what this might break in TB
                let box: BoundingBox = object!.box
                let rect: TensorBoxRect = TensorBoxRect(classID: -1, xmin: box.xmin, ymin: box.ymin, xmax: box.xmax, ymax: box.ymax)
                rects.append(rect)
            }
            let tbe:TensorBoxElement = TensorBoxElement(id: id, imagePath: imagePath, rects: rects)
            tbes.append(tbe)
        }
        return TensorBoxElementSet(tb: tbes)
    }
    
    func encode(url: URL, voc: VOCElementSet?) throws {
        print("writing to : \(url)")
        let tbes = translate(voc: voc)
        try encode(url: url, tbes: tbes)
    }
    
    func encode(url: URL, tbes: TensorBoxElementSet?) throws {
        print("writing to : \(url)")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if #available(OSX 10.13, *) {
                encoder.outputFormatting = .sortedKeys
            } else {
                // Fallback on earlier versions
            } // follow the lexicographical order
            let data = try! encoder.encode(tbes)
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print("TensorBoxJSON.encode: \(error)")
        }
        return
    }
    
    func getParsed() -> TensorBoxElementSet? {
        return self.tensorBoxElementSet
    }
    
}
