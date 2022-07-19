//
//  AppDelegate.swift
//  Global Hits Radio
//
//  Created by Macbook Pro on 06/04/2020.
//  Copyright © 2020 Muhammad Haris Butt. All rights reserved.


//

import UIKit
import AFNetworking
import SwiftEventBus
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var lastRadioStatus = RadioStatus()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
              Fabric.with([Crashlytics.self])
        sleep(2)
        self.pollServerRequestForUpdatedMetaData()
        application.beginReceivingRemoteControlEvents()
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.didEnterBackgroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    @objc func willResignActive(_ notification: Notification) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
 
    
    func pollServerRequestForUpdatedMetaData(){
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
            self.makeGetRequest()
        }
    }
    
    func makeGetRequest() {
        
        let manager = AFHTTPSessionManager()
        manager.get(
            "https://public.radio.co/stations/sef292cd6f/status",
            parameters: nil,
            headers: nil,
            progress: nil,
            success: { (sessionTask, responseObject) in
                
                guard let jsonObject = responseObject as? [String: Any] else {
                      return
                }
                guard let currentTrack = jsonObject["current_track"] as? [String: Any] else {
                      return
                }
                guard let historyList = jsonObject["history"] as? [[String: Any]] else {
                      return
                }
                let artWorkImageUrl = currentTrack["artwork_url_large"] as? String
                let trackTitle = currentTrack["title"] as? String
                let updatedRadioStatusObj = RadioStatus()
                 updatedRadioStatusObj.trackTitle =  ""
                updatedRadioStatusObj.artworkLargeUrl = artWorkImageUrl ?? ""
                updatedRadioStatusObj.trackTitle = trackTitle ?? ""
                for songHistory in historyList {
                    let songName = songHistory["title"]
                    updatedRadioStatusObj.songsHistory.append(songName as! String)
                    debugPrint(songName.debugDescription)
                }
                if(self.lastRadioStatus.trackTitle != updatedRadioStatusObj.trackTitle){
                    self.lastRadioStatus = updatedRadioStatusObj
                    SwiftEventBus.post("updateMetaData", sender: self.lastRadioStatus)
                }
        }) { (sessionTask, error) in
            debugPrint("Error: " + error.localizedDescription)
        }
    }
}

