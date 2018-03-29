//
//  PageVIew.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/28.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

class PageView: UIView {
    
    fileprivate var titles : [String]!
    fileprivate var controllers : [UIViewController]!
    fileprivate var style : PageTitleStyle!
    fileprivate var parentController : UIViewController!
    fileprivate var titleView : PageTitleView!
    fileprivate var contentView : PageContentView!

    init(frame : CGRect, titles : [String], controllers : [UIViewController], parentController : UIViewController, style : PageTitleStyle) {
        
        self.titles = titles
        self.controllers = controllers
        self.style = style
        self.parentController = parentController
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI
extension PageView {
    
    private func setupUI() {
        
        setupTitleView()
        setupContentView()
    }
    
    private func setupTitleView() {
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: style.height)
        titleView = PageTitleView(frame: frame, titles: titles, style: style)
        titleView.delegate = self
        addSubview(titleView)
    }
    
    private func setupContentView() {
        let frame = CGRect(x: 0, y: style.height, width: bounds.width, height: bounds.height - style.height)
        contentView = PageContentView(frame: frame, viewControllers: controllers, parentVC: parentController)
        contentView.delegate = self
        addSubview(contentView)
        
    }
}

// MARK:- TitleView & contentView 代理
extension PageView : PageTitleViewDelegate {
    func pageTitleViewDidseleted(index: Int) {
        contentView.changeScreen(targetIndex: index)
    }
}

extension PageView: PageContentViewDelegate {
    func contentViewEndScroll(_: PageContentView, index: Int, process: CGFloat) {
        titleView.graduColor(index: index, progress: process);
    }
    
    func contentViewEndScroll(_: PageContentView, index: Int) {
        titleView.adjustTitleLablePosition(targetIndex: index)
    }
}

