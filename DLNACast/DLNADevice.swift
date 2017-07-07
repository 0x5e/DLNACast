//
//  DLNADevice.swift
//  DLNACast
//
//  Created by 高森 on 2017/7/7.
//  Copyright © 2017年 0x5e. All rights reserved.
//

import Foundation
import CocoaSSDP
import KissXML

public class DLNADevice {
    public var uuid: String!
    public var name: String!
    public var location: URL!
    
    public var controlURL: String!
    public var eventSubURL: String!
    public var SCPDURL: String!
    
    // 获取设备描述文档(DDD)
    // https://eliyar.biz/DLNA_with_iOS_Android/
    
    public init?(ssdpService: SSDPService) {
        do {
            let data = try Data(contentsOf: ssdpService.location)
            let document = try DDXMLDocument(data: data, options: 0)
            let deviceNode = document.rootElement()!.elements(forName: "device")[0]
            let serviceNodes = deviceNode.elements(forName: "serviceList")[0].elements(forName: "service")
            for serviceNode in serviceNodes {
                if serviceNode.elements(forName: "serviceType")[0].stringValue != SSDPServiceType_UPnP_AVTransport1 {
                    continue
                }
                
                uuid = ssdpService.uniqueServiceName
                location = ssdpService.location
                name = deviceNode.elements(forName: "friendlyName")[0].stringValue
                controlURL = serviceNode.elements(forName: "controlURL")[0].stringValue
                eventSubURL = serviceNode.elements(forName: "eventSubURL")[0].stringValue
                SCPDURL = serviceNode.elements(forName: "SCPDURL")[0].stringValue
            }
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
