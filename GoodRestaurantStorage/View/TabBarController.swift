//
//  TabBarController.swift
//  GoodRestaurantStorage
//
//  Created by 앱지 Appg on 2021/07/28.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    // 메인 지도 화면
    var mainTabBar: MainViewController = {
        let vc = MainViewController()
        let defaultImg = UIImage(systemName: "house")
        let selectedImg = UIImage(systemName: "house.fill")
        let tabBarItem = UITabBarItem(title: nil, image: defaultImg, selectedImage: selectedImg)
        vc.tabBarItem = tabBarItem
        tabBarItem.tag = 0
        return vc
    }()
    
    // 프로필 화면
    var profileTabBar: UINavigationController = {
        let vc = ProfileViewController()
        let defaultImg = UIImage(systemName: "person.circle")
        let selectedImg = UIImage(systemName: "person.circle.fill")
        let tabBarItem = UITabBarItem(title: nil, image: defaultImg, selectedImage: selectedImg)
        vc.tabBarItem = tabBarItem
        tabBarItem.tag = 1
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "회사 주변 맛집"
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewControllers = [mainTabBar, profileTabBar]
    }
}
