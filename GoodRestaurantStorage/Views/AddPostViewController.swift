//
//  AddPostViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/08/01.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import FirebaseDatabase
import FirebaseAuth
import Toast_Swift

class AddPostViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var ref = Database.database().reference()
    
    //MARK: - UI property
    private let placeName: UILabel = {
        let lb = UILabel()
        lb.text = "가게"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        return lb
    }()
    
    private let placeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "가게 이름을 작성해주세요."
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let menuName: UILabel = {
        let lb = UILabel()
        lb.text = "메뉴"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        return lb
    }()
    
    private let menuTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "메뉴 이름을 작성해주세요."
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let price: UILabel = {
        let lb = UILabel()
        lb.text = "가격"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        return lb
    }()
    
    private let priceTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "가격을 작성해주세요."
        tf.keyboardType = .numberPad
        return tf
    }()
    
    private let review: UILabel = {
        let lb = UILabel()
        lb.text = "한줄 후기"
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        return lb
    }()
    
    private let reviewTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "한줄 후기를 작성해주세요."
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let addBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("추가", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.orange, for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderWidth = 2.0
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.cornerRadius = 8.0
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonActions()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Add button
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints {
            $0.bottom.equalTo(-tabBarHeight(view, tabBarController: tabBarController!) - 20)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(35)
        }
    }
    
    
    //MARK:- Setup UI
    private func setupUI() {
        
        view.backgroundColor = .white
        
        // Place name
        view.addSubview(placeName)
        placeName.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.leading.equalTo(20)
        }
        
        view.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeName.snp.bottom).offset(8)
            $0.leading.equalTo(placeName)
            $0.trailing.equalTo(-20)
        }
        
        // Menu name
        view.addSubview(menuName)
        menuName.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.leading.equalTo(placeName)
        }
        
        view.addSubview(menuTextField)
        menuTextField.snp.makeConstraints {
            $0.top.equalTo(menuName.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(placeTextField)
        }
        
        // Review
        view.addSubview(review)
        review.snp.makeConstraints {
            $0.top.equalTo(menuTextField.snp.bottom).offset(24)
            $0.leading.equalTo(placeName)
        }
        
        view.addSubview(reviewTextField)
        reviewTextField.snp.makeConstraints {
            $0.top.equalTo(review.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(placeTextField)
        }
    }
    
    //MARK: - Button Actions
    private func buttonActions() {
        
        // Add
        addBtn.rx.tap
            .bind {
                let postRef = self.ref.child("post").childByAutoId()
                let currentUser = Auth.auth().currentUser?.email!.replacingOccurrences(of: ".", with: "_")
                let placeName = self.placeTextField.text
                let menuName = self.menuTextField.text
                let review = self.reviewTextField.text
                
                if placeName == "" {
                    self.view.makeToast("가게 이름을 입력해주세요 !", duration: 1.5, position: .center)
                } else if menuName == "" {
                    self.view.makeToast("메뉴 이름을 입력해주세요 !", duration: 1.5, position: .center)
                } else {
                    let value: [String: Any] = ["user": currentUser!, "place_name": placeName!, "menu_name": menuName!, "review": review!]
                    postRef.setValue(value)
                    
                    let alert = UIAlertController(title: "맛집 추가에 성공했습니다 !", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.placeTextField.text = ""
                        self.menuTextField.text = ""
                        self.reviewTextField.text = ""
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
