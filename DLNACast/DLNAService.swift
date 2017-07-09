//
//  DLNAService.swift
//  DLNACast
//
//  Created by 高森 on 2017/7/7.
//  Copyright © 2017年 0x5e. All rights reserved.
//

import CocoaSSDP
import KissXML

public protocol DLNADiscoveryDelegate: class {
    func dlna(service: DLNAService, didFind device: DLNADevice)
}

public class DLNAService: SSDPServiceBrowserDelegate {
    var ssdpService: SSDPServiceBrowser!
    weak var delegate: DLNADiscoveryDelegate?
    
    init() {
        ssdpService = SSDPServiceBrowser(serviceType: SSDPServiceType_UPnP_AVTransport1)
        ssdpService.delegate = self
    }
    
    public var deviceList = [DLNADevice]()
    public var isSearching = false
    
    public func startDiscovery() {
        isSearching = true
        deviceList.removeAll()
        ssdpService.startBrowsingForServices()
    }
    
    public func stopDiscovery() {
        isSearching = false
        ssdpService.stopBrowsingForServices()
    }
    
    // MARK: SSDPServiceBrowserDelegate
    
    public func ssdpBrowser(_ browser: SSDPServiceBrowser!, didFind service: SSDPService!) {
        let dlnaDevice = DLNADevice(ssdpService: service)!
        deviceList.append(dlnaDevice)
        print("DLNA device found: \(dlnaDevice.name!)")
        
        if let delegate = self.delegate {
            delegate.dlna(service: self, didFind: dlnaDevice)
        }
    }
    
    public func ssdpBrowser(_ browser: SSDPServiceBrowser!, didRemove service: SSDPService!) {
//        deviceList.remove(service)
    }
    
    public func ssdpBrowser(_ browser: SSDPServiceBrowser!, didNotStartBrowsingForServices error: Error!) {
        print("SSDP Service Error: \(error)")
    }
    
    // MARK: SOAP
    
    public func playAction(device: DLNADevice) {
        // TODO: Screen streaming
        // http://www.cnblogs.com/damiao/p/5233431.html
        
//        let mediaUrl = "https://qgy18.com/jsvideo/MPEG1/fox.mpg"
//        let mediaUrl = "http://flv.bn.netease.com/tvmrepo/2012/7/C/7/E868IGRC7-mobile.mp4"
//        let mediaUrl = "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"
//        let mediaUrl = "rtmp://192.168.0.101:1935/live1/room1"
        let mediaUrl = "http://192.168.0.101/test.mp4"
        
        let meta = try! DDXMLDocument(xmlString: String(contentsOf: Bundle.main.url(forResource: "meta", withExtension: "xml")!), options: 0)
        
        let action = SOAPAction(device: device, serviceType: SSDPServiceType_UPnP_AVTransport1, actionName: "SetAVTransportURI", params: ["CurrentURI": mediaUrl, "InstanceID": "0", "CurrentURIMetaData": meta])
        action.action(successHandler: {
            print("SetAVTransportURI action success")
            
            let action = SOAPAction(device: device, serviceType: SSDPServiceType_UPnP_AVTransport1, actionName: "Play", params: ["InstanceID": "0", "Speed": "1"])
            action.action(successHandler: {
                print("Play action success")
            }, errorHandler: {error in
                print("Play action error")
            })
        }, errorHandler: {error in
            print("SetAVTransportURI action error")
        })
    }
    
    public func stopAction(device: DLNADevice) {
        let action = SOAPAction(device: device, serviceType: SSDPServiceType_UPnP_AVTransport1, actionName: "Stop", params: ["InstanceID": "0"])
        action.action(successHandler: {
            print("Play action success")
        }, errorHandler: {error in
            print("Play action error")
        })
    }
    
}
