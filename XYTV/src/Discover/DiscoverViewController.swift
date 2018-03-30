//
//  HomeViewController.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/25.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

private let kContentCell = "kContentCell"

class DiscoverViewController: MainNavigationController {
    fileprivate lazy var collectionView  : UICollectionView = {
        let layout = CJWaterfallLayout()
        layout.datasource = self
        let margin : CGFloat = 10.0
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        let collectionV = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCell)
        collectionV.dataSource = self
        return collectionV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }


}

extension DiscoverViewController {
    func setupUI() {
        view.backgroundColor = UIColor.randomColor()
        setupWaterfallView()
    }
    
    // 瀑布流
    private func setupWaterfallView() {
        view.addSubview(collectionView)
        
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCell, for: indexPath)
        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
        
    }

}

extension DiscoverViewController: CJWaterfallLayoutDataSource {
    func heightForItem(_: CJWaterfallLayout, indexPath: IndexPath) -> CGFloat {
        return CGFloat(arc4random_uniform(100) + 100)
    }
    
    func numberOfColsInWaterfallLayout(_ layout: CJWaterfallLayout) -> Int {
        return 3
    }
}
