//
//  ViewController.swift
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

import AppKit
import TensorBoxify

class ViewController: NSViewController, NSBrowserDelegate {
    
    var urls : [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    enum FileTypes: String {
        case json = "json"
        case xml = "xml"
    }
    
    var allowedFileTypes: [FileTypes] = [(FileTypes.xml)]

    @IBOutlet weak var file_browser: NSBrowser!
    
    @IBAction func url_browser(_ sender: Any) {
            
        let dialog = NSOpenPanel();
            
        dialog.title                   = "Choose a file or directory containing images & annotations";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = true;
        dialog.allowedFileTypes        = getAllowedFileTypes();
            
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.urls
            if (result.count > 0) {
                urls.append(contentsOf: dialog.urls) //= dialog.urls
                // update the dialog box....
                //file_browser.add
                
                //url_browser(sender: urls)
                fileCount.integerValue = urls.count
                // for now, we are parsing on "ok" but eventually want to put this under control of "go" button...
                return
                //ingestFiles(urls: urls)
                //return
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBOutlet weak var fileSet: NSBrowser!
    
    @IBAction func fileTypeSelectionSwitch(_ sender: NSButton) {
        let label: String = (sender.title).lowercased()
        let action: Int = sender.state.rawValue
        let tag: FileTypes = FileTypes(rawValue:label)!
        if allowedFileTypes.contains(tag) {
            if action == 0 {
                allowedFileTypes.remove(at: allowedFileTypes.index(of: tag)!)
                //allowedFileTypes.remove(anObject: tag)
            }
        } else if action == 1 {
            allowedFileTypes.append(tag)
        }
        print("test \(allowedFileTypes)")
    }
    
    private func getAllowedFileTypes() -> [String] {
        var allowed: [String] = []
        
        for case let suffix in allowedFileTypes {
            let tag = suffix.rawValue
            allowed.append(tag)
        }
        return allowed
    }
    
    func ingestFiles (urls: [URL]) {
        // add new selections to combo box
        /*let parser = VOCXMLParser();
        for uri in self.urls {
            _ = MetaFile(metaURI: uri);
            let vo : VOCElement = parser.decode(url: uri)!;
            print("Processed \(vo)" );
        }*/
    }
    @IBOutlet weak var fileCount: NSTextField!
}

    /*
    func (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {
    if (item) {
    return [[item objectForKey:@"children"] count];
    }
    return [browserData count];
    }
    
    - (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    if (item) {
    return [[item objectForKey:@"children"] objectAtIndex:index];
    }
    return [browserData objectAtIndex:index];
    }
    
    - (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    return [item objectForKey:@"children"] == nil;
    }
    
    - (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {
    return [item objectForKey:@"name"];
    }*/
    

