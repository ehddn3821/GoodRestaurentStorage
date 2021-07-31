//
//  Extensions.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/28.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

// 최상위 뷰컨트롤러 가져오기
//  UIApplication.shared.windows.first?.visibleViewController
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


// 탭바에 그림자 넣기
func setupTabBarShadow(_ tabBar: UITabBar) {
    UITabBar.clearShadow()
    tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
}

extension CALayer {
    // Sketch 스타일의 그림자를 생성하는 유틸리티 함수
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}


// 애플 로그인 버튼 rx.tap 추가
@available(iOS 13.0, *)
extension Reactive where Base: ASAuthorizationAppleIDButton {
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}
