//
//  TabBarController.swift
//  GoodRestaurantStorage
//
//  Created by 앱지 Appg on 2021/07/28.
//

import UIKit

class TabBarController: CustomTabBarController {
    
    // 메인 화면
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
        var vc = ProfileViewController()
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
        
        self.tabBar.tintColor = .systemIndigo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.viewControllers = [self.mainTabBar, self.profileTabBar]
    }
}
