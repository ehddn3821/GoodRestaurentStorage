//
//  MainViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/26.
//

import UIKit
import SnapKit
import FirebaseDynamicLinks
import FirebaseStorage

class MainViewController: UIViewController {
    
    let storage = Storage.storage()
    
    lazy var testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "성공"
        lb.isHidden = true
        return lb
    }()
    
    private let foodImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let screenWidth = UIScreen.main.bounds.width
        
        view.addSubview(foodImageView)
        foodImageView.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(screenWidth - 40)
        }
        
        downloadImage(imageView: foodImageView)
        createDynamicLink()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dlAction), name: Notification.Name(rawValue: "clickFirebaseDynamicLink"), object: nil)
    }
    
    
    func downloadImage(imageView: UIImageView) {
        
        storage.reference(forURL: "gs://goodrestaurantstorage.appspot.com/test").downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.foodImageView.image = image
        }
    }
    
    @objc func dlAction() {
        testLabel.isHidden = false
    }
    
    func createDynamicLink() {
        let link = URL(string: "https://goodrestaurantstorage.page.link/OpenEvent?eventId=1")
        let referralLink = DynamicLinkComponents(link: link!, domainURIPrefix: "https://goodrestaurantstorage.page.link")
        
        // iOS 설정
        referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.dwkang.GoodRestaurantStorage")
        referralLink?.iOSParameters?.minimumAppVersion = "1.0"
        referralLink?.iOSParameters?.appStoreID = "1579672517"
//        referralLink?.iOSParameters?.customScheme = "커스텀 스키마가 설정되어 있을 경우 추가"
        
        // 단축 URL 생성
        referralLink?.shorten { (shortURL, warnings, error) in
            if let error = error {
                Log.error(error.localizedDescription)
                return
            }
            Log.info(shortURL)
        }
    }
}
