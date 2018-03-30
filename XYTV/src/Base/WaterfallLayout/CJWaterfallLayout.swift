//
//  CJWaterfallLayout.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/3/29.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

@objc protocol CJWaterfallLayoutDataSource: class {
    func heightForItem(_ : CJWaterfallLayout, indexPath : IndexPath) -> CGFloat
    @objc optional func numberOfColsInWaterfallLayout(_ layout : CJWaterfallLayout) -> Int
}

class CJWaterfallLayout: UICollectionViewFlowLayout {
    // 此时已知数据： collectionView的属性 、 flowlayout的属性
    
    weak var datasource: CJWaterfallLayoutDataSource?
    fileprivate lazy var cols : Int = {
        let cols = self.datasource?.numberOfColsInWaterfallLayout!(self) ?? 3
        return cols
    }()
    fileprivate lazy var colsHeights : [CGFloat] = Array(repeating: 0, count: self.cols)
    fileprivate lazy var layoutAttrbutes = [UICollectionViewLayoutAttributes]()
}

// MARK:- 准备工作
extension CJWaterfallLayout {
    override func prepare() {
        super.prepare()
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        let w : CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols-1) * minimumInteritemSpacing) / CGFloat(cols)
        
        for i in 0..<itemCount {
            let indexPath = IndexPath(row: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let height = datasource?.heightForItem(self, indexPath: indexPath) else {
                fatalError("请设置数据源并返回\(indexPath)的数据")
            }
            let h : CGFloat = height
            let miniHeight = colsHeights.min()!
            let miniIndex = colsHeights.index(of: miniHeight)!
            let x : CGFloat = sectionInset.left + CGFloat(miniIndex) * (w + minimumInteritemSpacing)
            let y = i < 3 ? miniHeight + sectionInset.top : miniHeight + minimumLineSpacing
            attr.frame = CGRect(x: x, y: y, width: w, height: h)
            print(y)
            //print("x:\(x),y:\(y),w:\(w),h:\(h)")
            layoutAttrbutes.append(attr)
            colsHeights[miniIndex] = miniHeight + minimumLineSpacing + h
        }
        
    }
}

// MARK:- 返回数据
extension CJWaterfallLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttrbutes;
    }
}



// MARK:- 重新设置ContentView的size
extension CJWaterfallLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: colsHeights.max()! + sectionInset.bottom)
    }
}
