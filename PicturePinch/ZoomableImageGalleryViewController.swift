//
//  ZoomableImageGalleryViewController.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/13/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

class ZoomableImageGalleryViewController: UIViewController {

    let zoomableImageGalleryView = ZoomableImageGalleryView()
    
    var dataSource: ZoomableImageGalleryViewDataSource? {
        get { return zoomableImageGalleryView.dataSource }
        set {
            zoomableImageGalleryView.dataSource = newValue
            zoomableImageGalleryView.reloadContent()
        }
    }
    override func loadView() {
        view = zoomableImageGalleryView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
            
                self?.zoomableImageGalleryView.animateAlongsideTransitionToSize(size)
                
            },
            completion: { [weak self] _ in
                
                self?.zoomableImageGalleryView.completedTransitionToSize(size)
                
        })
        
    }

}
