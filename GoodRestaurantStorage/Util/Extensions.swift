//
//  Extensions.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/28.
//

import UIKit

// 최상위 뷰컨트롤러 가져오기
extension UIWindow {
    
    public var visibleViewController: UIViewController? {
        return self.visibleViewControllerFrom(vc: self.rootViewController)
    }
    
    public func visibleViewControllerFrom(vc: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return self.visibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return self.visibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return self.visibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}
