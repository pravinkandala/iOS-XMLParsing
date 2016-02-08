//
//  XMLParser.swift
//  XMLParsing
//
//  Created by Pravin Kandala on 2/3/16.
//  Copyright © 2016 Pravin Kandala. All rights reserved.
//

import UIKit

protocol XMLParserDelegate{
    func XMLParserError(parser: XMLParser, error: String)
}

class XMLParser: NSObject, NSXMLParserDelegate {

    let url: NSURL
    var delegate: XMLParserDelegate?
    
    var objects = [Dictionary<String,String>]()
    var object = Dictionary<String,String>()
    
    var inItem = false
    var current = String()
    
    var handler: (()-> Void)?
    
    init(url: NSURL) {
        self.url = url
    }
    
    func parse(handler:() -> Void){
        self.handler = handler
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            //another thread
            
            let xmlCode = NSData(contentsOfURL: self.url)
//            let string = NSString(data: xmlCode!, encoding: NSASCIIStringEncoding)
//            print(string)
            let parser = NSXMLParser(data: xmlCode!)
           parser.delegate = self
            if !parser.parse(){
                
            self.delegate?.XMLParserError(self, error: "Parsing Failed")
                
            }
            
        }
        
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        delegate?.XMLParserError(self, error: parseError.localizedDescription)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "entry"{
        object.removeAll(keepCapacity: false)
            inItem = true
        }
        current = elementName
        
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if !inItem{
            return
        }
        if let temp = object[current]{
            var tempString = temp
            tempString += string
            object[current] = tempString
        }
        else{
            object[current] = string
        }
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "entry"{
            inItem = false
            
            objects.append(object)
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_main_queue()){
           //Main queue
            if (self.handler != nil){
                self.handler!()
            }
        }
    }
}

