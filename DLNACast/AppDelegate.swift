//
//  AppDelegate.swift
//  DLNACast
//
//  Created by 高森 on 2017/7/7.
//  Copyright © 2017年 0x5e. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var separatorItem: NSMenuItem!
    
    var statusItem: NSStatusItem!
    var service: DLNAService!
    var toggleOn = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        let image : NSImage = NSImage(named: NSImage.Name(rawValue: "menu_icon"))!
        image.isTemplate = true
        statusItem.image = image
        statusItem.menu = statusMenu
        
        service = DLNAService()
    }
    
    // MARK: Menu
    
    func menuWillOpen(_ menu: NSMenu) {
        if toggleOn {
            statusMenu.items[0].title = "DLNA: On"
            statusMenu.items[1].title = "Close DLNA"
        } else {
            statusMenu.items[0].title = "DLNA: Off"
            statusMenu.items[1].title = "Open DLNA"
        }
        
        reloadDeviceItems()
    }
    
    func reloadDeviceItems() {
        if service.deviceList.count > 0 {
            separatorItem.isHidden = false
        } else {
            separatorItem.isHidden = true
        }
        
        let startIndex = 3
        while !statusMenu.items[startIndex].isSeparatorItem {
            statusMenu.removeItem(at: startIndex)
        }
        
        for device in service.deviceList {
            let item = NSMenuItem(title: device.name!, action: #selector(selectAction), keyEquivalent: device.uuid!)
            statusMenu.insertItem(item, at: startIndex)
        }
    }
    
    @IBAction func toggleAction(_ sender: NSMenuItem) {
        toggleOn = !toggleOn
        if toggleOn {
            print("Start DLNA Discovery")
            service.startDiscovery()
        } else {
            print("Stop DLNA Discovery")
            service.stopDiscovery()
        }
    }
    
    @IBAction func selectAction(_ sender: NSMenuItem) {
//        sender.state = .on
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

}

