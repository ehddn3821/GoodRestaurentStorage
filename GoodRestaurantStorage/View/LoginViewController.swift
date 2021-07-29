//
//  LoginViewController.swift
//  GoodRestaurantStorage
//
//  Created by 앱지 Appg on 2021/07/28.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    let appleLoginBtn = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        appleLoginBtn.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // 로그인 버튼 탭
    @objc func appleLogin(_ sender: ASAuthorizationAppleIDButton) {
        AppleLoginManager.shared.startSignInWithAppleFlow()
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // 네비게이션바 높이 가져오기
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//        let statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        // 애플 로그인 버튼
        self.view.addSubview(appleLoginBtn)
        appleLoginBtn.snp.makeConstraints { make in
//            make.top.equalTo(pwTextField.snp.bottom).offset(50)
            make.centerY.equalToSuperview()
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(35)
        }
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Preview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        LoginViewController().toPreview()
    }
}
#endif
