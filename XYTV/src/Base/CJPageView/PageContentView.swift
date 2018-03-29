//
//  PageContentView.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/28.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit


let kcellIdentifiler = "kcellIdentifiler"

protocol PageContentViewDelegate: class {
    func contentViewEndScroll( _ : PageContentView, index : Int)
    func contentViewEndScroll( _ : PageContentView, index : Int, process : CGFloat)
    
}

class PageContentView: UIView {
    weak var delegate : PageContentViewDelegate?
    var startOffset : CGFloat = 0.0
    
    fileprivate var isTagEvent = true
    fileprivate var viewControllers : [UIViewController]!
    fileprivate var parentVC : UIViewController!
    fileprivate lazy var collectionView : UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: bounds.width, height: bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionV = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kcellIdentifiler)
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.bounces = false
        collectionV.scrollsToTop = false
        collectionV.isPagingEnabled = true
        collectionV.showsHorizontalScrollIndicator = false
        return collectionV
    }()

    init(frame : CGRect, viewControllers : [UIViewController], parentVC : UIViewController) {
        self.viewControllers = viewControllers
        self.parentVC = parentVC
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK:- 设置UI
extension PageContentView {
    private func setupUI() {
        addSubview(collectionView)
        
    }
}

extension PageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTagEvent = false
        startOffset = collectionView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isTagEvent {
            return
        }
        let scrollOffset = collectionView.contentOffset.x - startOffset
        if scrollOffset == 0 {
            return;
        }
        let index = (startOffset / collectionView.bounds.width) + scrollOffset / abs(scrollOffset)
        let progress = abs(scrollOffset/collectionView.bounds.width)
        print(scrollOffset, index)
        delegate?.contentViewEndScroll(self, index: Int(index), process: progress)
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    func contentEndScroll() {
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentViewEndScroll(self, index: index)
        
    }
}

// MARK:- UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kcellIdentifiler, for: indexPath)
        
        for sub in cell.contentView.subviews {
            sub.removeFromSuperview()
        }
        let vc = viewControllers[indexPath.row]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
}

// MARK:- 事件响应
extension PageContentView {
    func changeScreen(targetIndex : Int) {
        guard targetIndex < viewControllers.count else {
            return
        }
        isTagEvent = true
        collectionView.scrollToItem(at: IndexPath(row: targetIndex, section: 0), at: .left, animated: false)
        
    }
    
}








