//
//  ZoomableImageGalleryViewController.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/13/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

protocol ZoomableImageGalleryViewControllerProtocol {
    func selectPage(_ page: Int)
}

class ZoomableImageGalleryViewController: UIViewController, ZoomableImageGalleryViewControllerProtocol {

    let zoomableImageGalleryView = ZoomableImageGalleryView()
    private var initialPage: Int = 0
    private var didSelectInitialPage = false
    var dataSource: ZoomableImageGalleryViewDataSource? {
        get { return zoomableImageGalleryView.dataSource }
        set {
            zoomableImageGalleryView.dataSource = newValue
            zoomableImageGalleryView.reloadContent()
        }
    }
    
    init(initialPage: Int = 0) {
        self.initialPage = initialPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        view = zoomableImageGalleryView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didSelectInitialPage == false {
            zoomableImageGalleryView.selectPage(initialPage)
            didSelectInitialPage = true
        }
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
    
    func selectPage(_ page: Int) {
        zoomableImageGalleryView.selectPage(page)
    }

}
