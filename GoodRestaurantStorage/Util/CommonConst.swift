//
//  CommonConst.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/30.
//

import UIKit

// 탭바 높이
func tabBarHeight(_ view: UIView, tabBarController: UITabBarController) -> Int {
    return Int(view.frame.height - tabBarController.tabBar.frame.minY)
}

struct Constants {
    
    static var firebaseDynamicLink = ""
    
    static let screenWidth = UIScreen.main.bounds.width
}
