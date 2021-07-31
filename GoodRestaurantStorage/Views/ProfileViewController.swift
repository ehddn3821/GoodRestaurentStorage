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
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    //MARK: - UI Property
    private let appleLoginBtn = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    private let signOutBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Out !", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.red, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.cornerRadius = 8.0
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if UserDefaults.standard.bool(forKey: "user") {
            signOutBtn.isHidden = false
            appleLoginBtn.isHidden = true
        } else {
            signOutBtn.isHidden = true
            appleLoginBtn.isHidden = false
        }
    }
    
    
    //MARK: - setup
    private func setup() {
        
        self.view.backgroundColor = .white
        
        
        // 애플 로그인 버튼
        self.view.addSubview(appleLoginBtn)
        appleLoginBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(35)
        }
        
        appleLoginBtn.rx.tap
            .bind{
                AppleLoginManager.shared.startSignInWithAppleFlow()
            }.disposed(by: disposeBag)
        
        
        // 로그아웃 버튼
        self.view.addSubview(signOutBtn)
        signOutBtn.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-tabBarHeight(view, tabBarController: tabBarController!) - 20)
            $0.height.equalTo(35)
        }
        
        signOutBtn.rx.tap
            .bind {
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
                
                self.present(alert, animated: true)
            }.disposed(by: disposeBag)
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
