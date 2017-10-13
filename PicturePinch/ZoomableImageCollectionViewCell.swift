//
//  ZoomableImageCollectionViewCell.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/13/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

protocol ZoomableImageCollectionViewCellProtocol {
    var zoomImage: ZoomableImageView { get }
}

class ZoomableImageCollectionViewCell: UICollectionViewCell, ZoomableImageCollectionViewCellProtocol {
    
    let zoomImage = ZoomableImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        setUpViewHierarchy()
        styleViews()
    }
    
    private func setUpViewHierarchy() {
        
        let views = ["zi" : zoomImage]
        views.values.forEach({
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let horz = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[zi]-0-|", options: [], metrics: nil, views: views)
        let vert = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[zi]-0-|", options: [], metrics: nil, views: views)
        let constraints = horz + vert
        constraints.forEach({ $0.isActive = true })
        
    }
    
    private func styleViews() {
        
        contentView.backgroundColor = .red
        zoomImage.backgroundColor = .blue
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        zoomImage.image = nil
    }
    
}
