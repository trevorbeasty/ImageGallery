//
//  ZoomableImageGalleryView.swift
//  PicturePinch
//
//  Created by Trevor Beasty on 10/13/17.
//  Copyright © 2017 Trevor Beasty. All rights reserved.
//

import UIKit

protocol ZoomableImageGalleryViewDataSource {
    func numberOfImages() -> Int
    func configureZoomableImage(_ zoomImage: ZoomableImageView, withIndex index: Int)
}

protocol ZoomableImageGalleryViewDelegate {
    
}

protocol ZoomableImageGalleryViewProtocol {
    var minZoom: CGFloat { get set }
    var maxZoom: CGFloat { get set }
    var dataSource: ZoomableImageGalleryViewDataSource? { get set }
    func reloadContent()
    func invalidateCollectionViewLayout()
    func correctContentOffset()
    func resetZoomScales()
}

class ZoomableImageGalleryView: UIView, ZoomableImageGalleryViewProtocol {
    
    fileprivate let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    fileprivate let pageControl = UIPageControl()
    fileprivate let cellID = "ZoomableImageCollectionViewCell"
    
    var dataSource: ZoomableImageGalleryViewDataSource? {
        didSet {
            updatePageControl()
            collectionView.reloadData()
        }
    }
    var delegate: ZoomableImageGalleryViewDelegate?
    var minZoom: CGFloat = 1.0
    var maxZoom: CGFloat = 4.0
    
    fileprivate var transitionCells: [ZoomableImageCollectionViewCell] = []
    
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
        setUpCollectionView()
        setUpPageControl()
    }
    
    private func setUpViewHierarchy() {
        
        let views = [
            "cv" : collectionView,
            "pc" : pageControl
        ]
        
        let metrics = [
            "a" : 0,
            "b" : 8,
            "pcHeight" : 44
        ]
        
        views.values.forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let horz1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-a-[cv]-a-|", options: [], metrics: metrics, views: views)
        let horz2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-b-[pc]-b-|", options: [], metrics: metrics, views: views)
        let vert = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cv]-0-[pc(==pcHeight)]-0-|", options: [], metrics: metrics, views: views)
        let constraints = horz1 + horz2 + vert
        constraints.forEach({ $0.isActive = true })
        
    }
    
    private func styleViews() {
    
        collectionView.isPagingEnabled = true
        
        pageControl.backgroundColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .green
    
    }

    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ZoomableImageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    private func setUpPageControl() {
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlValueDidChange(sender:)), for: .valueChanged)
    }
    
    private func updatePageControl() {
        pageControl.numberOfPages = dataSource?.numberOfImages() ?? 0
    }
    
    func pageControlValueDidChange(sender: UIPageControl) {
        print("page control value did change")
    }
    
    func reloadContent() {
        collectionView.reloadData()
    }
    
    func invalidateCollectionViewLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func correctContentOffset() {
        let indexPath = IndexPath(row: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func resetZoomScales() {
        
        guard let ds = dataSource else { return }
        
        for i in 0..<ds.numberOfImages() {
            
            let ip = IndexPath(row: i, section: 0)
            if let cell = collectionView.cellForItem(at: ip) as? ZoomableImageCollectionViewCell {
                cell.zoomImage.zoomScale = 1.0
            }
            
        }
    }
    
}

extension ZoomableImageGalleryView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = dataSource?.numberOfImages() ?? 0
        print(count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ZoomableImageCollectionViewCell
        
        cell.zoomImage.minZoom = minZoom
        cell.zoomImage.maxZoom = maxZoom
        
        dataSource?.configureZoomableImage(cell.zoomImage, withIndex: indexPath.row)
        
        return cell
    
    }
    
}

extension ZoomableImageGalleryView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ZoomableImageGalleryView: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        transitionCells.removeAll()
        
        if let cv = scrollView as? UICollectionView {
            
            cv.visibleCells.forEach({
                if let cell = $0 as? ZoomableImageCollectionViewCell {
                    transitionCells.append(cell)
                }
            })
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        transitionCells.forEach({
            
            if isVisible(view: $0.contentView) == false {
                $0.zoomImage.zoomScale = 1.0
            }
            
        })
        
        guard let cv = scrollView as? UICollectionView else { return }
        
        cv.visibleCells.forEach({
            
            let row = cv.indexPath(for: $0)!.row
            
            if $0.frame.origin == cv.contentOffset {
                pageControl.currentPage = row
            }

        })
    
    }
    
}

func isVisible(view: UIView) -> Bool {
    func isVisible(view: UIView, inView: UIView?) -> Bool {
        guard let inView = inView else { return true }
        let viewFrame = inView.convert(view.bounds, from: view)
        if viewFrame.intersects(inView.bounds) {
            return isVisible(view: view, inView: inView.superview)
        }
        return false
    }
    return isVisible(view: view, inView: view.superview)
}


































