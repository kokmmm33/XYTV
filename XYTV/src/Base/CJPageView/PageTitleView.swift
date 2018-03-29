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
    
    fileprivate lazy var btnLine : UIView = {
        let line = UIView()
        line.backgroundColor = self.titleStyle.btnLineColor
        line.frame.size.height = self.titleStyle.btnLineHeight
        line.frame.origin.y = self.bounds.height - self.titleStyle.btnLineHeight
        return line
    }()
    
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
        setupButtonLine()
        setupTitlelabels()
        setupTitlePosition()
        
    }
    
    func setupButtonLine() {
        if titleStyle.isShowBtnLine {
            scrollView.addSubview(btnLine)
        }
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
            
            if titleStyle.isShowBtnLine {
                btnLine.frame.size.width = titlelabels[0].frame.width
                btnLine.frame.origin.x = titleStyle.itemMargin * 0.5
            }
            
        } else {
            w = bounds.width / CGFloat(titlelabels.count)
            for (i, label) in titlelabels.enumerated() {
                x = CGFloat(i) * w
                label.frame = CGRect(x: x, y: y, width: w, height: h)
            }
            
            if titleStyle.isShowBtnLine {
                btnLine.frame.size.width = w
                btnLine.frame.origin.x = 0
            }
        }
        
        
    }
}

// MARK:- 事件响应
extension PageTitleView {
    @objc func titileLableClick(_ ges : UIGestureRecognizer) {
        guard let lable = ges.view else {
            return
        }
        // 调整lable位置
        adjustTitleLablePosition(targetLalbel: lable as! UILabel)
        
        // buttonline 滚动
        if titleStyle.isShowBtnLine {
            UIView.animate(withDuration: 0.25) {
                self.btnLine.frame.origin.x = lable.frame.origin.x
                self.btnLine.frame.size.width = lable.bounds.width
            }
        }
        // 通知代理
        delegate?.pageTitleViewDidseleted(index: currentIndex)
    }
    
    // 改变titleLable的position
    public func adjustTitleLablePosition(targetIndex : Int) {
        adjustTitleLablePosition(targetLalbel: titlelabels[targetIndex])
    }
    
    func adjustTitleLablePosition(targetLalbel : UILabel) {
        let currentLable = titlelabels[currentIndex]
        guard targetLalbel.tag != currentIndex else {
            return
        }
        
        // 改变字体颜色
        currentLable.textColor = titleStyle.color
        targetLalbel.textColor = titleStyle.selectedColor
        
        // 改变lable居中
        let lableCenterX = targetLalbel.center.x
        let centerX = center.x
        var offset : CGFloat = 0.0
        
        if lableCenterX > centerX{
            offset = lableCenterX - centerX
            let maxOffset = scrollView.contentSize.width - bounds.width
            offset = offset > maxOffset ? maxOffset : offset
        }
        scrollView.setContentOffset(CGPoint(x : offset, y : 0), animated: true)
        
        currentIndex = targetLalbel.tag
    }
    
    // titleLalbe的颜色渐变
    public func graduColor(index : Int, progress : CGFloat) {
        let targetLable = titlelabels[index]
        let originLalbe = titlelabels[currentIndex]
        
        let targetRGB = titleStyle.selectedColor.getCgcolor()
        let originRGB = titleStyle.color.getCgcolor()
        let deletaRGB = UIColor.getRGBDelta(firstColor: titleStyle.selectedColor, secondColor: titleStyle.color)
        
       
        targetLable.textColor = UIColor(r: originRGB.0 + deletaRGB.0*progress, g: originRGB.1 + deletaRGB.1*progress, b: originRGB.2 + deletaRGB.2*progress)
        originLalbe.textColor = UIColor(r: targetRGB.0 - deletaRGB.0*progress, g: targetRGB.1 - deletaRGB.1*progress, b: targetRGB.2 - deletaRGB.2*progress)
        print("targetLable:\(targetLable.textColor.getCgcolor()),originLalbe:\(originLalbe.textColor.getCgcolor())\n")
        
        // buttonline 滚动
        if titleStyle.isShowBtnLine {
            let deletaX = targetLable.frame.origin.x - originLalbe.frame.origin.x
            let deletaW = targetLable.bounds.width - originLalbe.bounds.width
            btnLine.frame.origin.x = originLalbe.frame.origin.x + deletaX * progress
            btnLine.frame.size.width = originLalbe.bounds.width + deletaW * progress
            
        }
        
    }
}









