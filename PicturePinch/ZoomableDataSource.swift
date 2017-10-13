//
//  ZoomableDataSource.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/13/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

class ZoomableDataSource: ZoomableImageGalleryViewDataSource {
    
    let images = [#imageLiteral(resourceName: "rabbits"), #imageLiteral(resourceName: "rabbits"), #imageLiteral(resourceName: "rabbits")]
    
    func numberOfImages() -> Int {
        return images.count
    }
    
    func configureZoomableImage(_ zoomImage: ZoomableImageView, withIndex index: Int) {
        let image = images[index]
        zoomImage.image = image
    }
    
}
