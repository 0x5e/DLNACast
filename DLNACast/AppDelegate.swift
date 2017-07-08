//
//  AppDelegate.swift
//  DLNACast
//
//  Created by 高森 on 2017/7/7.
//  Copyright © 2017年 0x5e. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, DLNADiscoveryDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var statusItem: NSMenuItem!
    @IBOutlet weak var toggleItem: NSMenuItem!
    @IBOutlet weak var separatorItem: NSMenuItem!
    
    var statusBarItem: NSStatusItem!
    var service: DLNAService!
    var toggleOn = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let image : NSImage = NSImage(named: NSImage.Name(rawValue: "menu_icon"))!
        image.isTemplate = true
        statusBarItem.image = image
        statusBarItem.menu = statusMenu
        
        service = DLNAService()
        service.delegate = self
    }
    
    // MARK: Menu
    
    @IBAction func toggleAction(_ sender: NSMenuItem) {
        toggleOn = !toggleOn
        if toggleOn {
            print("Start DLNA Discovery")
            statusItem.title = "DLNA: On"
            toggleItem.title = "Close DLNA"
            service.startDiscovery()
        } else {
            print("Stop DLNA Discovery")
            statusItem.title = "DLNA: Off"
            toggleItem.title = "Open DLNA"
            service.stopDiscovery()
            
            // remove device list
            separatorItem.isHidden = true
            for _ in 0..<service.deviceList.count {
                statusMenu.removeItem(at: 3)
            }
        }
    }
    
    @IBAction func selectAction(_ sender: NSMenuItem) {
        for item in statusMenu.items {
            item.state = (item == sender) ? .on : .off
        }
        
        for device in service.deviceList {
            if device.uuid != sender.keyEquivalent {
                continue
            }
            service.playAction(device: device)
        }
    }
    
    @IBAction func settingAction(_ sender: NSMenuItem) {
        
    }
    
    @IBAction func aboutAction(_ sender: NSMenuItem) {
        
    }
    
    // MARK: DLNADiscoveryDelegate
    
    func dlna(service: DLNAService, didFind device: DLNADevice) {
        if service.deviceList.count == 1 {
            separatorItem.isHidden = false
        }
        
        statusMenu.insertItem(withTitle: device.name!, action: #selector(selectAction), keyEquivalent: device.uuid!, at: 2 + service.deviceList.count)
    }
}

