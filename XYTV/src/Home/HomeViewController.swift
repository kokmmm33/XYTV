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
        view.backgroundColor = UIColor.randomColor()
        setupNavigationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        searchBar.endEditing(true)
    }
    
}

// MARK:- 设置UI
extension HomeViewController {
    
    
    // MARK:- 导航条
    fileprivate func setupNavigationBar() {
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
    
}

// MARK:- 事件处理

extension HomeViewController {
    
    @objc fileprivate func collectItemClick() {
        print("ssss")
    }
    
    
    
}











