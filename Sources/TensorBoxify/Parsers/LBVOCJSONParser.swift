//
//  LBVOCJSONParser.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

/*
 {
 "filename" : "lepage-170604-DGP-9916.jpg",
 "folder" : "images",
 "image_w_h" : [
 4928,
 3280
 ],
 "objects" : [
 {
 "label" : "carconenumber-1",
 "x_y_w_h" : [
 2287,
 1865,
 391,
 235
 ]
 },
 {
 "label" : "camera-camera",
 "x_y_w_h" : [
 2304,
 788,
 377,
 322
 ]
 },
 {
 "label" : "car-bottom-front-1",
 "x_y_w_h" : [
 570,
 770,
 3782,
 2347
 ]
 }
 ]
 }
 */

public class LBVOCJSONParser: VOCParser {
    
    
    var vocElementSet: VOCElementSet? = nil
    
    func decode(data: Data) throws {
        
        let decoder = JSONDecoder(context: VersionContext(responseType: "json"))
        do {
            let vocArray: [VOCElement] = try decoder.decode([VOCElement].self, from: data)
            vocElementSet = VOCElementSet(images: vocArray)
            return
        } catch {
            // try singleton
            let vocArray = [try decoder.decode(VOCElement.self, from: data)]
            vocElementSet = VOCElementSet(images: vocArray)
            return
        }
    }
    
    func encode(voc: VOCElementSet) throws -> Data {
        //http://benscheirman.com/2017/06/ultimate-guide-to-json-parsing-with-swift-4/
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(voc)
    }
    
    func translate(tbes: TensorBoxElementSet) -> VOCElementSet {
        var voca: [VOCElement] = []
        tbes.images.forEach { image in
            let folder: String = extractFolder(name: image.imagePath)
            let filename: String = extractFilename(name: image.imagePath)
            // todo: read image and derive dimensions
            let dimensions: Dimensions = Dimensions(dimensions: [Int(0),Int(0)] )!
            let segmented: Int = 0
            
            var objects: [Object?] = []
            image.rects.forEach { rect in
                let object: Object = Object(label: "unknown", box: BoundingBox(box: [rect.xmin, rect.ymin, rect.xmax, rect.ymax])!)
                objects.append(object)
            }
            let voc: VOCElement = VOCElement(folder: folder, filename: filename, dimensions: dimensions, segmented: segmented, objects: objects)
            voca.append(voc)
        }
        return VOCElementSet(images: voca)
    }
    
    
    func encode(tbes: TensorBoxElementSet) throws -> Data{
        return try encode(voc: translate(tbes: tbes))
    }
    
    func getParsed() -> VOCElementSet? {
        return self.vocElementSet
    }
}

