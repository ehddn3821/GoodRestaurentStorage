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
import FirebaseStorage
import Toast_Swift

class AddPostViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    //MARK: - UI property
    private func labelMaker(_ title: String) -> UILabel {
        let lb = UILabel()
        lb.text = title
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        return lb
    }
    
    private func textFieldMaker(_ placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        return tf
    }
    
    var placeTextField = UITextField()
    var menuTextField = UITextField()
    var reviewTextField = UITextField()
    
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
                    
                    // 사진 업로드
                    self.uploadImage(image: UIImage(named: "google")!)
                    
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
    
    func uploadImage(image: UIImage) {
        
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let filePath = "test"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storage.reference().child(filePath).putData(data, metadata: metaData) { (metaData, error) in
            if let error = error {
                Log.error(error.localizedDescription)
                return
            } else {
                Log.info("사진 업로드 성공")
            }
        }
    }
    
    
    //MARK:- Setup UI
    private func setupUI() {
        
        view.backgroundColor = .white
        
        // Place name
        let placeName = labelMaker("가게")
        view.addSubview(placeName)
        placeName.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.leading.equalTo(20)
        }
        
        placeTextField = textFieldMaker("가게 이름을 작성해주세요.")
        view.addSubview(placeTextField)
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeName.snp.bottom).offset(8)
            $0.leading.equalTo(placeName)
            $0.trailing.equalTo(-20)
        }
        
        // Menu name
        let menuName = labelMaker("메뉴")
        view.addSubview(menuName)
        menuName.snp.makeConstraints {
            $0.top.equalTo(placeTextField.snp.bottom).offset(24)
            $0.leading.equalTo(placeName)
        }
        
        menuTextField = textFieldMaker("메뉴 이름을 작성해주세요.")
        view.addSubview(menuTextField)
        menuTextField.snp.makeConstraints {
            $0.top.equalTo(menuName.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(placeTextField)
        }
        
        // Review
        let review = labelMaker("한줄 후기")
        view.addSubview(review)
        review.snp.makeConstraints {
            $0.top.equalTo(menuTextField.snp.bottom).offset(24)
            $0.leading.equalTo(placeName)
        }
        
        reviewTextField = textFieldMaker("한줄 후기를 작성해주세요.")
        view.addSubview(reviewTextField)
        reviewTextField.snp.makeConstraints {
            $0.top.equalTo(review.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(placeTextField)
        }
        
        // Photo
        let photoLB = labelMaker("사진")
        view.addSubview(photoLB)
        photoLB.snp.makeConstraints {
            $0.top.equalTo(reviewTextField.snp.bottom).offset(24)
            $0.leading.equalTo(placeName)
        }
    }
}
