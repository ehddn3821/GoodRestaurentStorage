//
//  ProfileViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/28.
//

import UIKit
import SnapKit
import FirebaseAuth
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    //MARK: - UI Property
    private let snsSignInLabel: UILabel = {
        let lb = UILabel()
        lb.text = "SNS 계정을 사용하여 로그인"
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    lazy var snsSignInStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [appleSignInBtn, googleSignInBtn])
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private let appleSignInBtn: UIButton = {
        let btn = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        btn.setImage(UIImage(systemName: "applelogo", withConfiguration: largeConfig), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        return btn
    }()
    
    private let googleSignInBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "google"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.black.cgColor
        return btn
    }()
    
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
        setupUI()
        buttonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if UserDefaults.standard.bool(forKey: "user") {
            signOutBtn.isHidden = false
            snsSignInLabel.isHidden = true
            snsSignInStackView.isHidden = true
        } else {
            signOutBtn.isHidden = true
            snsSignInLabel.isHidden = false
            snsSignInStackView.isHidden = false
        }
    }
    
    override func viewWillLayoutSubviews() {
        appleSignInBtn.layer.cornerRadius = appleSignInBtn.frame.width / 2
        googleSignInBtn.layer.cornerRadius = appleSignInBtn.frame.width / 2
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        
        view.backgroundColor = .white
        
        // SNS stackView
        view.addSubview(snsSignInStackView)
        snsSignInStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // Apple button
        appleSignInBtn.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        // Google button
        googleSignInBtn.snp.makeConstraints {
            $0.width.height.equalTo(appleSignInBtn)
        }
        
        // SNS label
        view.addSubview(snsSignInLabel)
        snsSignInLabel.snp.makeConstraints {
            $0.bottom.equalTo(snsSignInStackView.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        // Sign out button
        view.addSubview(signOutBtn)
        signOutBtn.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-tabBarHeight(view, tabBarController: tabBarController!) - 20)
            $0.height.equalTo(35)
        }
    }
    
    //MARK: - Button Actions
    private func buttonActions() {
        
        // Apple sign in
        appleSignInBtn.rx.tap
            .bind {
                AppleSignInManager.shared.startSignInWithAppleFlow()
            }.disposed(by: disposeBag)
        
        // Google sign in
        googleSignInBtn.rx.tap
            .bind {
                GoogleSignInManager.shared.startSignInWithGoogleFlow()
            }.disposed(by: disposeBag)
        
        // Sign out
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
