//
//  LBVOCXMLParser.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

/**
 sample vocxml file form containing 3 named bounding boxes
 <annotation>
 <folder>images</folder>
 <filename>lepage-170604-DGP-9916.jpg</filename>
 <size>
 <width>4928</width>
 <height>3280</height>
 </size>
 <segmented>0</segmented>
 <object>
 <name>carconenumber-1</name>
 <bndbox>
 <xmin>2287</xmin>
 <ymin>1865</ymin>
 <xmax>2677</xmax>
 <ymax>2099</ymax>
 </bndbox>
 </object>
 <object>
 <name>camera-camera</name>
 <bndbox>
 <xmin>2304</xmin>
 <ymin>788</ymin>
 <xmax>2680</xmax>
 <ymax>1109</ymax>
 </bndbox>
 </object>
 <object>
 <name>car-bottom-front-1</name>
 <bndbox>
 <xmin>570</xmin>
 <ymin>770</ymin>
 <xmax>4351</xmax>
 <ymax>3116</ymax>
 </bndbox>
 </object>
 </annotation>
 */

// encode the XML via a navigation down the treed structure values... would love to have a systemic way to do this, but for now we'll take this

protocol CodingKeyXML: CodingKey {
    
    static func find(tag: String) -> CodingKeyXML?
}

extension CodingUserInfoKey {
    public static let versionContext: CodingUserInfoKey = CodingUserInfoKey(rawValue: "versionContext")!
}

public struct VersionContext {
    public var responseType: String
    public init(responseType: String) {
        self.responseType = responseType
    }
}

extension Decoder {
    public var versionContext: VersionContext? { return userInfo[.versionContext] as? VersionContext }
}

extension JSONDecoder {
    convenience init(context: VersionContext) {
        self.init()
        self.userInfo[.versionContext] = context
    }
    
    func set(context: VersionContext) {
        self.userInfo[.versionContext] = context
    }
}


extension VOCElementSet {
    
    enum CodingKeysXML: String, CodingKeyXML {
        case image = "annotations"
        
        static func find(tag: String) -> CodingKeyXML? {
            // test tag against self
            guard let parsingTag: CodingKeyXML? = VOCElementSet.CodingKeysXML(rawValue: tag) else {
                return VOCElement.CodingKeysXML.find(tag: tag)
            }
            return parsingTag
        }
    }
    
    
    func encodeXML() -> String? {
        //open
        var xmls = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        //children
        images.forEach { image in
            xmls.append(contentsOf: String(describing: image.encodeXML()))
        }
        //closure
        return xmls
    }
    
    public init(from decoder: Decoder) throws {
        var flag = (decoder.versionContext?.responseType)
        if (flag == nil) {
            flag = "json"
        }
        switch flag! {
        case "xml":
            let container = try decoder.container(keyedBy: CodingKeysXML.self)
            let imageset = try container.decode([VOCElement].self, forKey: .image)
            self.init(images: imageset)
            return
        default:
            break
        }
        throw VOCParserError.decodeError(desc: "unable to decode VOCElementSet")
    }
}

extension VOCElement {
    
    enum CodingKeysXML: String, CodingKeyXML {
        case folder = "folder"
        case filename = "filename"
        case size = "size"
        case width = "width"
        case height = "height"
        case segmented = "segmented"
        case object = "object"
        
        static func find(tag: String) -> CodingKeyXML? {
            // test tag against self
            guard let parsingTag = VOCElement.CodingKeysXML(rawValue: tag) else {
                return Object.CodingKeysXML.find(tag: tag)
            }
            return parsingTag
        }
    }
    
    enum DecodingKeysXML: String, CodingKey {
        case folder = "folder"
        case filename = "filename"
        case size = "size"
        case segmented = "segmented"
        case objects = "objects"
    }
    
    func encodeXML() -> String? {
        //open
        var xmls = "<\(VOCElementSet.CodingKeysXML.image.rawValue)>\n"
        //children
        xmls.append(contentsOf: "<\(CodingKeysXML.filename.rawValue)>\(folder)\n")
        objects.forEach {object in
            xmls.append(contentsOf: (String(describing: object?.encodeXML())))
        }
        //closure
        xmls.append(contentsOf: "/\(VOCElementSet.CodingKeysXML.image.rawValue)\n")
        return xmls
    }
}

extension Object {
    
    enum CodingKeysXML: String, CodingKeyXML {
        case name = "name"
        case bndbox = "bndbox"
        
        static func find(tag: String) -> CodingKeyXML? {
            // test tag against self
            guard let parsingTag: CodingKeyXML? = Object.CodingKeysXML(rawValue: tag) else {
                return BoundingBox.CodingKeysXML.find(tag: tag)
            }
            return parsingTag
        }
    }
    
    func encodeXML() -> String? {
        
        //open
        var xmls = "<\(VOCElement.CodingKeysXML.object.rawValue)>\n"
        
        //children
        xmls.append(contentsOf: "<\(Object.CodingKeysXML.name.rawValue)>\(label)\n")
        xmls.append(contentsOf: (String(describing: box.encodeXML())))
        
        //closure
        xmls.append(contentsOf: "</\(VOCElement.CodingKeysXML.object.rawValue)>\n")
        return xmls
    }
}


extension BoundingBox {
    
    // used for encodingXML
    enum CodingKeysXML: String, CodingKeyXML {
        case xmin = "xmin"
        case ymin = "ymin"
        case xmax = "xmax"
        case ymax = "ymax"
        
        static func find(tag: String) -> CodingKeyXML? {
            // test tag against self
            guard let parsingTag: CodingKeyXML? = BoundingBox.CodingKeysXML(rawValue: tag) else {
                return nil
            }
            return parsingTag
        }
    }
    
    func encodeXML() -> String? {
        
        //open
        var xmls = "<\(Object.CodingKeysXML.bndbox.rawValue)>\n"
        //children
        xmls.append(contentsOf: "<\(BoundingBox.CodingKeysXML.xmin.rawValue)>\(String(describing: xmin))</\(BoundingBox.CodingKeysXML.xmin.rawValue)>\n")
        xmls.append(contentsOf: "<\(BoundingBox.CodingKeysXML.ymin.rawValue)>\(String(describing: ymin))</\(BoundingBox.CodingKeysXML.ymin.rawValue)>\n")
        xmls.append(contentsOf: "<\(BoundingBox.CodingKeysXML.xmax.rawValue)>\(String(describing: xmax))</\(BoundingBox.CodingKeysXML.xmax.rawValue)>\n")
        xmls.append(contentsOf: "<\(BoundingBox.CodingKeysXML.ymax.rawValue)>\(String(describing: ymax))</\(BoundingBox.CodingKeysXML.ymax.rawValue)>\n")
        // close
        xmls.append(contentsOf: "</\(Object.CodingKeysXML.bndbox.rawValue)>\n")
        return xmls
    }
}

class LBVOCXMLParser: VOCParser {
    
    var vocElementSet: VOCElementSet?
    
    public func decode(url: URL) throws
    {
        // initializer for next document?
        do {
            let parser: XMLDictionaryParser? = try XMLDictionaryParser(contentsOf:(url as URL))
            let xmlDict = (parser?.getDict())!["root"]!
            let data = try JSONSerialization.data(withJSONObject: xmlDict)
            let decoder = JSONDecoder(context: VersionContext(responseType: "xml"))
            do {
                let vocElementSet = try decoder.decode(VOCElementSet.self, from: data)
                self.vocElementSet = vocElementSet
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            // throw forward the message
            throw VOCParserError.decodeError(desc: "rethrow \(error)")
        }
        return
    }
    
    public func encode(url: URL, voc: VOCElementSet?) throws {
        // open the file
        if (url.isFileURL) {
            //writing
            do {
                let xml: String? = voc?.encodeXML()
                print("\(String(describing: xml))")
                print("\n")
                //try text.write(to: url, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        } else {
            throw VOCParserError.fileError(desc: "http posts not supported")
        }
    }
    
    public func encode(url: URL, tbes: TensorBoxElementSet?) throws {
        // open the file
        if (url.isFileURL) {
            //writing
            do {
                //let xml: String? = tbes?.encodeXML()
                //print("\(xml)"
                
                //try text.write(to: url, atomically: false, encoding: .utf8)
            }
            catch {
                /* error handling here */
            }
        } else {
            throw VOCParserError.fileError(desc: "http posts not supported")
        }
    }
    
    public func encode(outStream: OutputStream, voc: VOCElement?) {
        //outStream!.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
    
    func getParsed() -> VOCElementSet? {
        return self.vocElementSet
    }
}
