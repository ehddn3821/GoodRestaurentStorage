//
//  ProfileViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/28.
//

import UIKit
import SnapKit
import FirebaseAuth
import AuthenticationServices

class ProfileViewController: UIViewController {
    
    let appleLoginBtn = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    var signoutBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        appleLoginBtn.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        signoutBtn.addTarget(self, action: #selector(signout), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if UserDefaults.standard.bool(forKey: "user") {
            signoutBtn.isHidden = false
            appleLoginBtn.isHidden = true
        } else {
            signoutBtn.isHidden = true
            appleLoginBtn.isHidden = false
        }
    }
    
    // 로그인
    @objc func appleLogin(_ sender: ASAuthorizationAppleIDButton) {
        AppleLoginManager.shared.startSignInWithAppleFlow()
    }
    
    // 로그아웃
    @objc func signout() {
        let alert = UIAlertController(title: "정말 로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            try! Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "user")
            Log.info("로그아웃")
            self.viewWillAppear(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        
        // 애플 로그인 버튼
        self.view.addSubview(appleLoginBtn)
        appleLoginBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(35)
        }
        
        // 로그아웃 버튼
        self.view.addSubview(signoutBtn)
        signoutBtn.setTitle("Sign Out !", for: .normal)
        signoutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signoutBtn.setTitleColor(.red, for: .normal)
        signoutBtn.backgroundColor = .white
        signoutBtn.layer.borderWidth = 2.0
        signoutBtn.layer.borderColor = UIColor.red.cgColor
        signoutBtn.layer.cornerRadius = 8.0
        signoutBtn.snp.makeConstraints { make in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.bottom.equalTo(-100)
            make.height.equalTo(35)
        }
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct PreviewProfileViewController: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        ProfileViewController().toPreview()
    }
}
#endif
