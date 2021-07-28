//
//  LoginViewController.swift
//  GoodRestaurantStorage
//
//  Created by 앱지 Appg on 2021/07/28.
//

import UIKit
import SnapKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var emailTextField = UITextField()
    var pwTextField = UITextField()
    let appleLoginBtn = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        appleLoginBtn.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
    }
    
    @objc func appleLogin(_ sender: ASAuthorizationAppleIDButton) {
        AppleLoginManager.shared.startSignInWithAppleFlow()
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        
        // 이메일
        self.view.addSubview(emailTextField)
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.placeholder = "이메일을 입력해주세요."
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(80)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
        }
        
        // 비밀번호
        self.view.addSubview(pwTextField)
        pwTextField.borderStyle = .roundedRect
        pwTextField.placeholder = "비밀번호를 입력해주세요."
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.leading.equalTo(emailTextField)
            make.trailing.equalTo(emailTextField)
        }
        
        // 애플 로그인 버튼
        self.view.addSubview(appleLoginBtn)
        appleLoginBtn.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(50)
            make.leading.equalTo(emailTextField)
            make.trailing.equalTo(emailTextField)
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
