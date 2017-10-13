//
//  ZoomableImageView.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/13/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

protocol ZoomableImageViewProtocol {
    init(frame: CGRect, image: UIImage?, minZoom: CGFloat, maxZoom: CGFloat)
    var image: UIImage? { get set }
    var zoomEnabled: Bool { get set }
    var minZoom: CGFloat { get set }
    var maxZoom: CGFloat { get set }
    var zoomScale: CGFloat { get set }
}

class ZoomableImageView: UIView, ZoomableImageViewProtocol {
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let imageView = UIImageView()

    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    var zoomEnabled: Bool = true
    var border: CGFloat = 0 {
        didSet {
            resetScrollViewConstraints()
        }
    }
    var zoomScale: CGFloat {
        get { return scrollView.zoomScale }
        set { scrollView.zoomScale = newValue }
    }
    var minZoom: CGFloat {
        get { return scrollView.minimumZoomScale }
        set { scrollView.minimumZoomScale = newValue }
    }
    var maxZoom: CGFloat {
        get { return scrollView.maximumZoomScale }
        set { scrollView.maximumZoomScale = newValue }
    }
    
    required init(frame: CGRect, image: UIImage? = nil, minZoom: CGFloat = 1.0, maxZoom: CGFloat = 4.0) {
        super.init(frame: frame)
        self.image = image
        self.minZoom = minZoom
        self.maxZoom = maxZoom
        setUpViewHierarchy()
        styleViews()
        scrollView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViewHierarchy()
        styleViews()
        scrollView.delegate = self
    }
    
    private func setUpViewHierarchy() {
        
        // scroll view set up
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints1 = scrollViewConstraints()
        constraints1.forEach({ $0.isActive = true })
        
        // image view set up
        
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let views2: [String:Any] = [
            "iv" : imageView
        ]
        
        let horz2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[iv]-0-|", options: [], metrics: nil, views: views2)
        let vert2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[iv]-0-|", options: [], metrics: nil, views: views2)
        let height = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1.0, constant: 0.0)
        let width = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0.0)
        let constraints2 = horz2 + vert2 + [height, width]
        constraints2.forEach({ $0.isActive = true })
        
    }
    
    private func styleViews() {
        
        scrollView.backgroundColor = .black
        
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        
    }
    
    private func scrollViewConstraints() -> [NSLayoutConstraint] {
        
        let views1: [String:Any] = [
            "sv" : scrollView
        ]
        
        let metrics1: [String:Any] = [
            "b" : border
        ]
        
        let horz1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-b-[sv]-b-|", options: [], metrics: metrics1, views: views1)
        let vert1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-b-[sv]-b-|", options: [], metrics: metrics1, views: views1)
        return horz1 + vert1
        
    }
    
    private func resetScrollViewConstraints() {
        
        scrollView.constraints.forEach({ $0.isActive = false })
        
        let newConstraints = scrollViewConstraints()
        newConstraints.forEach({ $0.isActive = true })
        
        layoutIfNeeded()
        
    }

}

extension ZoomableImageView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let view = zoomEnabled ? imageView : nil
        return view
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        // the following code calculates the required content inset (for the scroll view) such that the image is always centered / the scroll view does not allow scrolling into white space
        
        guard let image = imageView.image else { return }
        
        let widthRatio = image.size.width / scrollView.frame.size.width
        let heightRatio = image.size.height  / scrollView.frame.size.height
        let maxRatio = max(widthRatio, heightRatio)
        
        // get current image dimensions according to zoom
        
        let zoom1xWidth = image.size.width / maxRatio
        let zoom1xHeight = image.size.height / maxRatio
        let currentWidth = zoom1xWidth * scrollView.zoomScale
        let currentHeight = zoom1xHeight * scrollView.zoomScale
        
        // calculate excess content area in relation to scroll view & image size
        // when image dimension is smaller than scroll view frame dimension, content inset only depends on excess of scroll view content size dimension over scroll view frame dimension
        // when the image dimension is larger than scroll view frame dimension, must adjust the above content inset to allow scrolling over the entire image
        
        var excessWidth = scrollView.contentSize.width - scrollView.frame.width
        let excessWidthAdj = max(currentWidth - scrollView.frame.width, 0)
        excessWidth -= excessWidthAdj
        
        var excessHeight = scrollView.contentSize.height - scrollView.frame.height
        let excessHeightAdj = max(currentHeight - scrollView.frame.height, 0)
        excessHeight -= excessHeightAdj
        
        let horizontalInset = -1.0 * excessWidth / 2.0
        let verticalInset = -1.0 * excessHeight / 2.0
        
        let newContentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        scrollView.contentInset = newContentInset
        
    }
    
}













