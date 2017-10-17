//
//  AppDelegate.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/12/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        let dataSource = ZoomableDataSource()
        let zoomableImageGalleryVC = ZoomableImageGalleryViewController(initialPage: 2)
        zoomableImageGalleryVC.dataSource = dataSource
        
        window?.rootViewController = zoomableImageGalleryVC
        
    }

}

