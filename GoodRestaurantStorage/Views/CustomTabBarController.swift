//
//  CustumTabBarController.swift
//
//  TabBar 위에 그림자 생성
//
//  Created by 앱지 Appg on 2021/07/30.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewControllers = [mainTabBar, addPostTabBar, profileTabBar]
        selectedIndex = 2
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // 맛집 추가 탭은 로그인 세션 체크
        if viewController == addPostTabBar {
            if !UserDefaults.standard.bool(forKey: "user") {
                let alert = UIAlertController(title: "로그인이 필요합니다.", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.selectedIndex = 2
                }
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
                return false
            }
        }
        return true
    }
}
