//
//  ViewController.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/12/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var zoomableImageGallery: ZoomableImageGalleryView!
    
    let images = [#imageLiteral(resourceName: "rabbits"), #imageLiteral(resourceName: "rabbits"), #imageLiteral(resourceName: "rabbits")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpZoomableImageGallery()
    }
    
    private func setUpZoomableImageGallery() {
        zoomableImageGallery.dataSource = self
    }
    
}

extension ViewController: ZoomableImageGalleryViewDataSource {
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func configureZoomableImage(_ zoomImage: ZoomableImageView, withIndex index: Int) {
        let image = images[index]
        zoomImage.image = image
    }
    
}



