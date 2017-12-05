//
//  XMLDictionaryParser.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

public typealias XML = [String : Any]

extension Dictionary {
    func merged(another: [Key: Value]) -> Dictionary {
        var result: [Key: Value] = [:]
        for (key, value) in self {
            result[key] = value
        }
        for (key, value) in another {
            result[key] = value
        }
        return result
    }
}


// use a stack to track tag open/closure for proper hierarchy alignment
struct Stack <Element> {
    
    var stackArray : [Element] = []
    
    mutating func push(_ element: Element) {
        stackArray.append(element)
    }
    
    mutating func pop() -> Element? {
        return stackArray.popLast()
    }
    
    func peek() -> Element? {
        return stackArray.last
    }
}

class Node {
    static let multiKey : [String] = ["annotation", "object"]
    
    var children: [Node?] = []
    //var childIndex: [String] = []
    weak var parent: Node?
    var elementName: String = ""
    open var value: String = ""
    var attributes: String = ""
    
    init(_ parent: Node?,_ elementName: String) {
        self.parent = parent
        self.elementName = elementName
    }
    
    func addChild(_ node: Node?) {
        self.children.append(node)
        //self.childIndex.append((node?.elementName)!)
    }
    
    /*
     func uniqueChild(_ elementName: String) -> Bool {
     return children.filter{$0?.elementName == elementName}.count == 1
     //return childIndex.contains(elementName)
     }*/
    
    private func reifyParent(_ parent: Node?) {
        self.parent = parent
    }
    
    private func removeChild(_ node: Node?) {
        let position = children.index(where: {$0 === node})
        let _ = children.remove(at: position!)
    }
    
    func arrayify(nodeArray: [Node?]) -> [XML] {
        var dxml: [XML] = []
        nodeArray.forEach { deepchild in
            var child = deepchild?.flatten()
            if (child != nil) {
                let final = child!.popFirst()!.value as! XML
                dxml.append(final) // each child object has own Dictionary = problem with repeating tags - so just arrayify it
            }
            removeChild(deepchild)
        }
        return dxml
    }
    
    func flatten() -> XML {
        var xml: XML = [:]
        if (children.count == 0) { // leaf/child with only a value
            xml.updateValue(value, forKey: elementName)
            return xml
        } else { // parent object that has children
            var cxml: XML = [:]
            while (children.count > 0) {
                let child = children[0]
                // see if we have nested children with similar elementNames or if we expect to.... via Node.multiKey
                let test = children.filter{$0?.elementName == child?.elementName}
                if ((test.count > 1) || ((test.count == 1) && Node.multiKey.contains((child?.elementName)!))) { // determine if a tag occurs more than once
                    // found a multi so iterate for sisters and arrayify
                    let newElementName = (child?.elementName)!+"s" // just add an "s" to the common tag to represent the array of values
                    let temp: [XML] = arrayify(nodeArray: test)
                    cxml.updateValue(temp, forKey: newElementName) // add
                } else {
                    cxml = cxml.merged(another: (child?.flatten())!) // each child object has own Dictionary = problem with repeating tags
                    removeChild(child)
                }
            }
            xml.updateValue(cxml, forKey: elementName)
            return xml
        }
    }
}

class XMLDictionaryParser: NSObject, XMLParserDelegate {
    
    var parser: XMLParser
    var stack: Stack<Node> = Stack<Node>()
    var currentNode: Node? = Node(nil, "root")
    var xmlDict: XML? = nil
    
    let arrayifyElements = false
    
    init?(data: Data) throws {
        parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
        parser.parse()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        //new document
        stack.push(currentNode!)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // end of document -> Flatten to the expected Dictionary
        xmlDict = stack.pop()?.flatten()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        let aNode = Node(stack.peek(), elementName)
        currentNode?.addChild(aNode)
        stack.push(aNode)
        currentNode = aNode
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        let off = stack.pop()
        print("popNode: \(String(describing: off?.elementName)),\(String(describing: off?.value)) ")
        if (off?.elementName != elementName) {
            //TODO: we should be matching beginnings / ends w/in path -
            print("ERROR: found \(elementName) which did not match the top: \(String(describing: off)) on the stack: \(stack)")
        }
        currentNode = stack.peek()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (string.contains("\n")) {
            return } // remove carriage returns from parsed strings - hygiene
        currentNode?.value = string
        // TODO: establish appropriate typecast for value.. Int, Date, URL, String - by default there are no array types in XML
    }
    
    func getDict() -> XML? {
        return xmlDict
    }
    
}
