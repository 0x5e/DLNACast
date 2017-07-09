//
//  SOAPAction.swift
//  DLNACast
//
//  Created by 高森 on 2017/7/8.
//  Copyright © 2017年 0x5e. All rights reserved.
//

import Foundation
import KissXML

public class SOAPAction {
    var request: URLRequest
    
    public init(device: DLNADevice, serviceType: String, actionName: String, params: [String: Any]) {
        let url = URL(string: device.controlURL, relativeTo: device.location)!
        request = URLRequest(url: url)
        request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.setValue("\(serviceType)#\(actionName)", forHTTPHeaderField: "SOAPAction")
        
        let path = Bundle.main.path(forResource: "action", ofType: "xml")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let document = try! DDXMLDocument(data: data, options: 0)
        
        let actionNode = document.rootElement()?
            .elements(forName: "Body")[0]
            .children?[0] as! DDXMLElement
        
        actionNode.name = actionName
        actionNode.namespaces?[0].stringValue = serviceType
        
        for (key, value) in params {
            let node = DDXMLElement(name: key)
            if value is DDXMLElement {
                node.addChild(value as! DDXMLElement)
            } else if value is String {
                node.stringValue = value as? String
            }
            actionNode.addChild(node)
        }
        
        request.httpMethod = "POST"
        request.httpBody = document.xmlString.data(using: .utf8)
    }
    
    public func action(successHandler: @escaping () -> Swift.Void, errorHandler: @escaping (Error?) -> Swift.Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
                errorHandler(error)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode != 200 {
                let status = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                print("\(httpResponse.statusCode): \(status)")
                print(String(data: data!, encoding: .utf8)!)
                errorHandler(nil)
                return
            }
            
//            let document = try! DDXMLDocument(data: data!, options: 0)
            
            successHandler()
        }
        task.resume()
    }
}
