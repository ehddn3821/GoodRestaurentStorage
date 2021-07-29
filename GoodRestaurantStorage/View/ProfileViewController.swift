//
//  ProfileViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/28.
//

import UIKit
import SnapKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var signoutBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        signoutBtn.addTarget(self, action: #selector(signout), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if Auth.auth().currentUser == nil {
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
    
    // 로그아웃
    @objc func signout() {
        let alert = UIAlertController(title: "정말 로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            try! Auth.auth().signOut()
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
            Log.info("로그아웃")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func setUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(signoutBtn)
        signoutBtn.setTitle("Sign Out !", for: .normal)
        signoutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        signoutBtn.setTitleColor(.red, for: .normal)
        signoutBtn.backgroundColor = .white
        signoutBtn.layer.borderWidth = 2.0
        signoutBtn.layer.borderColor = UIColor.red.cgColor
        signoutBtn.layer.cornerRadius = 8.0
        signoutBtn.snp.makeConstraints { make in
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
struct PreviewProfileViewController: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        ProfileViewController().toPreview()
    }
}
#endif
