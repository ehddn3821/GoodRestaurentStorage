//
//  ProfileViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/28.
//

import UIKit
import SnapKit
import Firebase

class ProfileViewController: UIViewController {
    var signoutBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        signoutBtn.addTarget(self, action: #selector(signout), for: .touchUpInside)
        
        if Auth.auth().currentUser == nil {
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func signout() {
        do {
            try Auth.auth().signOut()
            Log.info("로그아웃 성공")
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        } catch let signOutError as NSError {
            Log.error("Error signing out", signOutError)
        }
    }
    
    private func setUI() {
        
        self.title = "프로필"
        self.view.backgroundColor = .white
        
        self.view.addSubview(signoutBtn)
        signoutBtn.setTitle("Sign Out", for: .normal)
        signoutBtn.setTitleColor(.white, for: .normal)
        signoutBtn.backgroundColor = .black
        signoutBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(80)
        }
    }
}
