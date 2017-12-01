//
//  VisualObjectClass.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

// a Dimension represents the image size width x height
struct Dimensions: Codable {
    var width: Int?
    var height: Int?
    
    enum CodingKeys: String, CodingKey {
        case width = "width"
        case height = "height"
    }
    
    //JSON decode
    init?(dimensions: [Int]) {
        if (dimensions.count == 2) {
            self.width = dimensions[0]
            self.height = dimensions[1]
        } else {
            self.width = 0
            self.height = 0
        }
    }
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}


extension Dimensions {
    
    public init(from decoder: Decoder) throws {
        // for whatever reason decoder was not producing ints
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let width = Int(try container.decode(String.self, forKey: .width))!
        let height = Int(try container.decode(String.self, forKey: .height))!
        self.init(width: width, height:height)
    }
}

// a BoundingBox represents a dimensioned rectangle... note that different representations
// exist for XML = xmin/xmax vs. JSON = xmin, width
struct BoundingBox: Codable {
    let xmin: Int
    let xmax: Int
    let ymin: Int
    let ymax: Int
    
    enum CodingKeys: String, CodingKey {
        case xmin = "x1"
        case xmax = "x2"
        case ymin = "y1"
        case ymax = "y2"
    }
    
    init?(xyxy: [Int]) {
        if (xyxy.count == 4) {
            xmin = xyxy[0]
            ymin = xyxy[1]
            xmax = xyxy[2]
            ymax = xyxy[3]
        } else {
            xmin = 0
            ymin = 0
            xmax = 0
            ymax = 0
        }
    }
    
    //RectLabel JSON decode - x,y,w,h
    init?(box: [Int]) {
        if (box.count == 4) {
            xmin = box[0]
            ymin = box[1]
            xmax = box[2] + self.xmin
            ymax = box[3] + self.ymin
        } else {
            xmin = 0
            ymin = 0
            xmax = 0
            ymax = 0
        }
    }
    
    public init(from decoder: Decoder) throws {
        //var id = -1 // for v1 structure id is -1
        var flag = (decoder.versionContext?.responseType)
        if (flag == nil) {
            flag = "json"
        }
        switch flag! {
        case "xml":
            // for whatever reason, XMLDictionary is not parsing Int's only strings??  otherwise we should be able to dump custom Decoder -> except maybe for the CodingKey strategy
            let container = try decoder.container(keyedBy: CodingKeysXML.self)
            self.xmin = Int(try container.decode(String.self, forKey: .xmin))!
            self.ymin = Int(try container.decode(String.self, forKey: .ymin))!
            self.xmax = Int(try container.decode(String.self, forKey: .xmax))!
            self.ymax = Int(try container.decode(String.self, forKey: .ymax))!
            break
        default:
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.xmin = (try container.decode(Int.self, forKey: .xmin))
            self.ymin = (try container.decode(Int.self, forKey: .ymin))
            self.xmax = (try container.decode(Int.self, forKey: .xmax))
            self.ymax = (try container.decode(Int.self, forKey: .ymax))
            break
        }
    }
}

// a vObject represents a named bounding box within an image (rectangle)
struct Object: Codable {
    var label: String
    var box: BoundingBox
    
    enum CodingKeys: String, CodingKey {
        case label = "label"
        case box = "x_y_w_h"
    }
}

extension Object {
    
    public init(from decoder: Decoder) throws {
        var flag = (decoder.versionContext?.responseType)
        if (flag == nil) {
            flag = "json"
        }
        var box: BoundingBox?
        var label: String?
        switch flag! {
        case "xml":
            let container = try decoder.container(keyedBy: CodingKeysXML.self)
            label = try container.decode(String.self, forKey: .name)
            box = try container.decode(BoundingBox.self, forKey: .bndbox)
            break
        default:
            let container = try decoder.container(keyedBy: CodingKeys.self)
            label = try container.decodeIfPresent(String.self, forKey: .label)
            let boxarray = try container.decodeIfPresent([Int].self, forKey: .box)
            if (boxarray != nil) {
                box = BoundingBox(box: boxarray!)
            } else {
                box = BoundingBox(box: [0,0,0,0])
            }
            break
        }
        self.init(label: label!, box: box!)
    }
}

// a VOCElement represents a singular image's annotations
struct VOCElement: Codable {
    var folder: String
    var filename: String
    var dimensions: Dimensions
    var segmented: Int?
    var objects: [Object?]
    
    enum CodingKeys: String, CodingKey {
        case folder = "folder"
        case filename = "filename"
        case dimensions = "image_w_h"
        case segmented = "segmented"
        case objects = "objects"
    }
    
}

struct VOCCodingOptions {
    enum Version {
        case fromXMLDict
        case fromJSON
        case toXML
    }
    let version = Version.fromJSON
    static let key = CodingUserInfoKey(rawValue: "com.mycompany.voccodingoptions")!
}

extension VOCElement {
    public init(from decoder: Decoder) throws {
        var flag = (decoder.versionContext?.responseType)
        if (flag == nil) {
            flag = "json"
        }
        switch flag! {
        case "xml":
            let container = try decoder.container(keyedBy: DecodingKeysXML.self)
            var segmented = 0
            let folder = try container.decode(String.self, forKey: .folder)
            let filename = try container.decode(String.self, forKey: .filename)
            let dims = try container.decode(Dimensions.self, forKey: .size)
            let segs = (try container.decodeIfPresent(String.self, forKey: .segmented))
            if (segs != nil) {
                segmented = Int(segs!)!
            }
            let objects = try container.decode([Object].self, forKey: .objects)
            self.init(folder: folder, filename: filename, dimensions: dims, segmented: segmented, objects: objects)
            break
        default: // standard JSON parsing
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var segmented = 0
            let folder = try container.decode(String.self, forKey: .folder)
            let filename = try container.decode(String.self, forKey: .filename)
            let dims = Dimensions(dimensions: (try container.decode([Int].self, forKey: .dimensions)))
            let segs = (try container.decodeIfPresent(Int.self, forKey: .segmented))
            if (segs != nil) {
                segmented = segs!
            }
            let objects = (try container.decodeIfPresent([Object].self, forKey: .objects))!
            self.init(folder: folder, filename: filename, dimensions: dims!, segmented: segmented, objects: objects)
            break
        }
    }
}

// Tensorbox requires a path'd filename
public func concatFilename(folder: String, file: String) -> String {
    return "\(folder)/\(file)"
}

public func extractFilename(name: String) -> String {
    let offset = name.range(of:"/", options: String.CompareOptions.backwards, range: nil, locale: nil)?.lowerBound
    var filename = (String(name.suffix(from: offset!)))
    filename.remove(at: filename.startIndex) // have to remove the "/"
    return filename
}

public func extractFolder(name: String) -> String {
    let offset = name.range(of:"/", options: String.CompareOptions.backwards, range: nil, locale: nil)?.lowerBound
    let folder = String(name.prefix(upTo: offset!))
    return folder
}

struct VOCElementSet: Codable {
    var images : [VOCElement]
    
    enum CodingKeys: String, CodingKey {
        case images = "images"
    }
    
    mutating func addVOC(voc: VOCElement) {
        images.append(voc)
    }
}
