//
//  VOCParser.swift
//  TensorBoxify
//
//  Created by Dan Hushon on 12/1/17.
//

import Foundation

protocol VOCParser {
    func decode(url: URL) throws
    func encode(url: URL, voc: VOCElementSet) throws
    func encode(url: URL, tbes: TensorBoxElementSet) throws
}

enum VOCParserError: Error {
    case fileError(desc: String)
    case decodeError(desc: String)
    case encodeError(desc: String)
}

public enum Parsers: String {
    case RectLabelXML = "Rect Label XML"
    case RectLabelJSON = "Rect Label JSON"
    case TensorBoxJSON = "Tensor Box JSON"
}

//ParserFactory is not yet used
public class ParserFactory {
    
    static let sharedInstance = ParserFactory()
    
    private var inputParser: Parsers
    private var outputParser: Parsers
    
    init() {
        inputParser = Parsers.RectLabelJSON
        outputParser = Parsers.TensorBoxJSON
    }
    
    func getParser(input: Parsers, output: Parsers)  { //-> VOCParser {
        self.inputParser = input
        self.outputParser = output
        // get access to the correct parser.
    }
    
}
