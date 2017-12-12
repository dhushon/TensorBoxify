//
//  AppDelegate.swift
//  MetaMerge
//
//  Created by Dan Hushon on 9/6/17.
//  Copyright © 2017 Dan Hushon. All rights reserved.
//
#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

