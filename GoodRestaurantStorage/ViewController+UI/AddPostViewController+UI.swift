//
//  AddPostViewController+UI.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/08/05.
//

import UIKit
import SnapKit

extension AddPostViewController {
    
    func labelMaker(_ title: String) -> UILabel {
        let lb = UILabel()
        lb.text = title
        lb.font = UIFont.boldSystemFont(ofSize: 22)
        return lb
    }
    
    func textFieldMaker(_ placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        return tf
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Add button
        view.addSubview(addBtn)
        addBtn.setTitle("추가", for: .normal)
        addBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addBtn.setTitleColor(.orange, for: .normal)
        addBtn.backgroundColor = .white
        addBtn.layer.borderWidth = 2.0
        addBtn.layer.borderColor = UIColor.orange.cgColor
        addBtn.layer.cornerRadius = 8.0
        addBtn.snp.makeConstraints {
            $0.bottom.equalTo(-tabBarHeight(view, tabBarController: tabBarController!) - 20)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(35)
        }
    }
    
    //MARK:- Setup UI
    func setupUI() {
        
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
        
        view.addSubview(addPhotoBtn)
        let addPhotoBtnImgConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .large)
        addPhotoBtn.setImage(UIImage(systemName: "plus.app", withConfiguration: addPhotoBtnImgConfig), for: .normal)
        addPhotoBtn.snp.makeConstraints {
            $0.top.equalTo(photoLB.snp.bottom).offset(20)
            $0.leading.equalTo(placeTextField)
            $0.width.height.equalTo(50)
        }
        
        view.addSubview(foodPhotoImgView)
        foodPhotoImgView.snp.makeConstraints {
            $0.top.leading.equalTo(addPhotoBtn)
            $0.width.height.equalTo(100)
        }
        
        view.addSubview(removeImgBtn)
        let removeImgBtnImgConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
        removeImgBtn.setImage(UIImage(systemName: "xmark.circle", withConfiguration: removeImgBtnImgConfig), for: .normal)
        removeImgBtn.tintColor = .orange
        removeImgBtn.backgroundColor = .white
        removeImgBtn.layer.cornerRadius = 20
        removeImgBtn.isHidden = true
        removeImgBtn.snp.makeConstraints {
            $0.top.equalTo(addPhotoBtn)
            $0.trailing.equalTo(foodPhotoImgView.snp.trailing)
            $0.width.height.equalTo(25)
        }
    }
}
