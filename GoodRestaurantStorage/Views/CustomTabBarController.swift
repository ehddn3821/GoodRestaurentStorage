//
//  CustumTabBarController.swift
//
//  TabBar 위에 그림자 생성
//
//  Created by 앱지 Appg on 2021/07/30.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var mainTabBar: MainViewController = {
        let vc = MainViewController()
        let defaultImg = UIImage(systemName: "house")
        let selectedImg = UIImage(systemName: "house.fill")
        let tabBarItem = UITabBarItem(title: nil, image: defaultImg, selectedImage: selectedImg)
        vc.tabBarItem = tabBarItem
        tabBarItem.tag = 0
        return vc
    }()
    
    var addPostTabBar: AddPostViewController = {
        var vc = AddPostViewController()
        let defaultImg = UIImage(systemName: "plus.app")
        let selectedImg = UIImage(systemName: "plus.app.fill")
        let tabBarItem = UITabBarItem(title: nil, image: defaultImg, selectedImage: selectedImg)
        vc.tabBarItem = tabBarItem
        tabBarItem.tag = 1
        return vc
    }()
    
    var profileTabBar: UINavigationController = {
        var vc = ProfileViewController()
        let defaultImg = UIImage(systemName: "person.circle")
        let selectedImg = UIImage(systemName: "person.circle.fill")
        let tabBarItem = UITabBarItem(title: nil, image: defaultImg, selectedImage: selectedImg)
        vc.tabBarItem = tabBarItem
        tabBarItem.tag = 2
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarShadow(tabBar)
        tabBar.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewControllers = [mainTabBar, addPostTabBar, profileTabBar]
        selectedIndex = 1
    }
}
