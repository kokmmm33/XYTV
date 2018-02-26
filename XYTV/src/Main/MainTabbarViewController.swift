//
//  MainTabbarViewController.swift
//  XYTV
//
//  Created by 蔡杰 on 2018/2/25.
//  Copyright © 2018年 Joseph. All rights reserved.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addsubViewController(name: "Home")
        addsubViewController(name: "Discover")
        addsubViewController(name: "Rank")
        addsubViewController(name: "Profile")
    }

    func addsubViewController(name : String) -> Void {
        let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
        if let vc = vc {
            addChildViewController(vc)
        }
    }

}
