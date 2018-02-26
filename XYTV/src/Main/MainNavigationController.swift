//
//  MainNavigationController.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/25.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    private func setupNavigationBar() {
        navigationBar.barTintColor = UIColor.black
    }
}
