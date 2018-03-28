//
//  PageTitleView.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/28.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate: class {
    func pageTitleViewDidseleted(index : Int)
    
}

class PageTitleView: UIView {
    fileprivate var titles : [String]
    fileprivate var titleStyle : PageTitleStyle
    fileprivate var titlelabels : [UILabel] = [UILabel]()
    fileprivate var currentIndex : Int = 0
    weak var delegate : PageTitleViewDelegate?
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollV = UIScrollView()
        // 必须是 lazy 属性 否则不能使用 self
        scrollV.frame = self.bounds
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.scrollsToTop = false
        return scrollV
    }()

    init(frame : CGRect, titles : [String], style : PageTitleStyle) {
        self.titles = titles
        self.titleStyle = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK:- 设置UI
extension PageTitleView {
    private func setupUI() {
        backgroundColor = .white
        addSubview(scrollView)
        setupTitlelabels()
        setupTitlePosition()
    }
    
    func setupTitlelabels() {
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.tag = i
            label.textColor = i == currentIndex ? titleStyle.selectedColor : titleStyle.color
            label.font = UIFont.systemFont(ofSize: titleStyle.fontSize)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            let tagGes = UITapGestureRecognizer(target: self, action: #selector(titileLableClick(_ : )))
            label.addGestureRecognizer(tagGes)

            scrollView.addSubview(label)
            titlelabels.append(label)
        
        }
    }
    
    func setupTitlePosition() {
        var x : CGFloat = 0.0
        let y : CGFloat = 0.0
        var w : CGFloat = 0.0
        let h : CGFloat = bounds.height
        
        if titleStyle.isScrollenable {
            for (i, label) in titlelabels.enumerated() {
                w = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: titleStyle.fontSize)], context: nil).width
                x = i == 0 ? titleStyle.itemMargin * 0.5 : titlelabels[i - 1].frame.maxX + titleStyle.itemMargin
                label.frame = CGRect(x: x, y: y, width: w, height: h)
            }
            scrollView.contentSize = CGSize(width: ((titlelabels.last?.frame.maxX)! + titleStyle.itemMargin * 0.5), height: bounds.height)
            
        } else {
            w = bounds.width / CGFloat(titlelabels.count)
            for (i, label) in titlelabels.enumerated() {
                x = CGFloat(i) * w
                label.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        }
    }
}

// MARK:- 事件响应
extension PageTitleView {
    @objc func titileLableClick(_ ges : UIGestureRecognizer) {
        adjustTitleLablePosition(targetIndex: ges.view!.tag)
        
        // 通知代理
        delegate?.pageTitleViewDidseleted(index: currentIndex)
    }
    
    public func adjustTitleLablePosition(targetIndex : Int) {
        let targetLable = titlelabels[targetIndex]
        let currentLable = titlelabels[currentIndex]
        guard targetIndex != currentIndex else {
            return
        }
        
        // 改变字体颜色
        currentLable.textColor = titleStyle.color
        targetLable.textColor = titleStyle.selectedColor
        
        // 改变lable居中
        let lableCenterX = targetLable.center.x
        let centerX = center.x
        var offset : CGFloat = 0.0
        
        if lableCenterX > centerX{
            offset = lableCenterX - centerX
            let maxOffset = scrollView.contentSize.width - bounds.width
            offset = offset > maxOffset ? maxOffset : offset
        }
        scrollView.setContentOffset(CGPoint(x : offset, y : 0), animated: true)
        currentIndex = targetLable.tag
    }
}









