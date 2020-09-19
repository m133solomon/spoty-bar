//
//  AppDelegate.swift
//  spoty-bar
//
//  Created by Mihai Solomon on 19.09.2020.
//  Copyright © 2020 Mihai Solomon. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    var popover: NSPopover!
    
    var statusBarItem: NSStatusItem!
    
    let currentSpotifyScript =
        """
        tell application "Spotify"
        if it is running then
            if player state is playing then
                set track_name to name of current track
                set artist_name to artist of current track

                if artist_name > 0
                    artist_name & " - " & track_name
                else
                    "~ " & track_name
                end if
            else
                "Nothing playing"
            end if
        end if
    end tell
    """

    var error: NSDictionary!
    var spotifyScript: NSAppleScript!
    
    let timeInterval = 2.0
    
    let prefix = ""
    // 🎧
    let notPlayingPrefix = ""
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let _ = ContentView()
        
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let songButton = self.statusBarItem.button {
            songButton.title = "spoty-bar"
        }
        
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.getSong), userInfo: nil, repeats: true)
        
        spotifyScript = NSAppleScript(source: currentSpotifyScript)!
    }
    
    @objc func getSong() {
        var result: String = notPlayingPrefix + "nothing playing"
        
        if let outputString = spotifyScript.executeAndReturnError(&error).stringValue {
            result = prefix + outputString
        }
        
        if let button = self.statusBarItem.button {
            button.title = result
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

