//
//  NickNameViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/08/05.
//

import UIKit
import SnapKit
import FirebaseDatabase
import FirebaseAuth
import RxCocoa
import RxSwift
import Toast_Swift

class NickNameViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let ref = Database.database().reference()
    
    lazy var nicknameStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nicknameLabel, nicknameTextField, saveButton])
        sv.axis = .vertical
        sv.spacing = 40
        sv.distribution = .equalSpacing
        return sv
    }()
    
    let nicknameLabel = UILabel()
    let nicknameTextField = UITextField()
    let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(nicknameStackView)
        nicknameStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-100)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        nicknameLabel.text = "사용할 닉네임을 입력해주세요 !"
        nicknameLabel.font = .boldSystemFont(ofSize: 22)
        
        nicknameTextField.borderStyle = .roundedRect
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .black
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8.0
        saveButton.snp.makeConstraints {
            $0.height.equalTo(35)
        }
        
        saveButton.rx.tap
            .bind {
                let currentUser = Auth.auth().currentUser?.email!.replacingOccurrences(of: ".", with: "_")
                let userRef = self.ref.child("user").child(currentUser!)
                
                if self.nicknameTextField.text == "" {
                    self.view.makeToast("닉네임을 입력해주세요 !", duration: 1.5, position: .center)
                } else {
                    
                    let value: [String: Any] = ["nick_name": self.nicknameTextField.text!]
                    userRef.setValue(value)
                    
                    let alert = UIAlertController(title: "닉네임 설정이 완료되었습니다 !", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

}
