//
//  DLNAService.swift
//  DLNACast
//
//  Created by 高森 on 2017/7/7.
//  Copyright © 2017年 0x5e. All rights reserved.
//

import CocoaSSDP

public class DLNAService: SSDPServiceBrowserDelegate {
    var ssdpService: SSDPServiceBrowser!
    
    init() {
        ssdpService = SSDPServiceBrowser(serviceType: SSDPServiceType_UPnP_AVTransport1)
        ssdpService.delegate = self
    }
    
    public var deviceList = [DLNADevice]()
    public var isSearching = false
    
    public func startDiscovery() {
        isSearching = true
        ssdpService.startBrowsingForServices()
    }
    
    public func stopDiscovery() {
        isSearching = false
        ssdpService.stopBrowsingForServices()
        deviceList.removeAll()
    }
    
    public func startStreamTo(device: DLNADevice) {
        // TODO
    }
    
    public func stopStreamTo(device: DLNADevice) {
        // TODO
    }
    
    // MARK: SSDPServiceBrowserDelegate
    
    public func ssdpBrowser(_ browser: SSDPServiceBrowser!, didFind service: SSDPService!) {
        for dlnaDevice in deviceList {
            if dlnaDevice.uuid == service.uniqueServiceName {
                return
            }
        }
        
        let device = DLNADevice(ssdpService: service)!
        deviceList.append(device)
    }
    
    public func ssdpBrowser(_ browser: SSDPServiceBrowser!, didRemove service: SSDPService!) {
//        deviceList.remove(service)
    }
    
    public func ssdpBrowser(_ browser: SSDPServiceBrowser!, didNotStartBrowsingForServices error: Error!) {
        print("SSDP Service Error: \(error)")
    }
}
