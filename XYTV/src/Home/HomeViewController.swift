//
//  HomeViewController.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/25.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

class HomeViewController: MainNavigationController {

    var searchBar : UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        searchBar.endEditing(true)
    }
}

// MARK:- 设置UI
extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.yellow
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
        setupPageView()
    }
    
    
    // MARK:- 导航条
    private func setupNavigationBar() {
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemClick))
        
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor.black
    }
    
    // MARK:- 设置pageView
    private func setupPageView() {
        //  由于自定义了导航栏，所有导航栏的高度增加了 10
        let frame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH  + 10, width: view.bounds.width, height: view.bounds.height - kNavigationBarH - kStatusBarH - 44)
        let titles = ["英雄联盟", "绝地求生", "地下城与勇士", "穿越火线", "捉妖记", "地下城与勇士", "穿越火线", "捉妖记"]
        let style = PageTitleStyle()
        style.isScrollenable = true
        style.itemMargin = 20.0
        var controllers = [UIViewController]();
        for _ in titles {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            controllers.append(vc)
        }
        
        let pageView = PageView(frame: frame, titles: titles, controllers: controllers, parentController: self, style: style)
        view.addSubview(pageView)
    }
}

// MARK:- 事件处理

extension HomeViewController {
    
    @objc fileprivate func collectItemClick() {
        print("ssss")
    }
}











