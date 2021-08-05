//
//  AddPostViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/08/01.
//

import UIKit
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
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return df
    }()
    
    // UI property
    var placeTextField = UITextField()
    var menuTextField = UITextField()
    var reviewTextField = UITextField()
    var addPhotoBtn = UIButton()
    var foodPhotoImgView = UIImageView()
    var removeImgBtn = UIButton()
    let addBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buttonActions()
    }
    
    
    //MARK: - Button Actions
    func buttonActions() {
        
        // Add photo
        addPhotoBtn.rx.tap
            .bind {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        // Remove photo
        removeImgBtn.rx.tap
            .bind {
                self.foodPhotoImgView.image = nil
                self.addPhotoBtn.isHidden = false
                self.removeImgBtn.isHidden = true
            }
            .disposed(by: disposeBag)
        
        // Add post
        addBtn.rx.tap
            .bind {
                // 현재시간을 id로 사용
                let currentDate = Date()
                let dateString = self.dateFormatter.string(from: currentDate)
                
                let postRef = self.ref.child(dateString)
                let currentUser = Auth.auth().currentUser?.email!.replacingOccurrences(of: ".", with: "_")
                let placeName = self.placeTextField.text
                let menuName = self.menuTextField.text
                let review = self.reviewTextField.text
                
                if placeName == "" {
                    self.view.makeToast("가게 이름을 입력해주세요 !", duration: 1.5, position: .center)
                } else if menuName == "" {
                    self.view.makeToast("메뉴 이름을 입력해주세요 !", duration: 1.5, position: .center)
                } else if self.foodPhotoImgView.image == nil {
                    self.view.makeToast("사진을 추가해주세요 !", duration: 1.5, position: .center)
                } else {
                    let value: [String: Any] = ["user": currentUser!, "place_name": placeName!, "menu_name": menuName!, "review": review!]
                    postRef.setValue(value)
                    
                    // 사진 업로드
                    self.uploadImage(id: dateString, image: self.foodPhotoImgView.image!)
                    
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
    
    func uploadImage(id: String, image: UIImage) {
        
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let filePath = id
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
}


//MARK: - UIImagePickerControllerDelegate
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            foodPhotoImgView.contentMode = .scaleAspectFit
            self.addPhotoBtn.isHidden = true
            self.removeImgBtn.isHidden = false
            foodPhotoImgView.image = pickedImage
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
