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
import FirebaseDatabase

class MainViewController: UIViewController {
    
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    var testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "성공"
        lb.isHidden = true
        return lb
    }()
    
    var foodImageView = UIImageView()
    var placeName = UILabel()
    var menuName = UILabel()
    var review = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createDynamicLink()
//        NotificationCenter.default.addObserver(self, selector: #selector(dlAction), name: Notification.Name(rawValue: "clickFirebaseDynamicLink"), object: nil)
        setupUI()
        getDatabase()
    }
    
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(placeName)
        placeName.snp.makeConstraints {
            $0.top.equalTo(100)
            $0.leading.equalTo(20)
        }
        
        view.addSubview(menuName)
        menuName.snp.makeConstraints {
            $0.top.equalTo(placeName.snp.bottom).offset(20)
            $0.leading.equalTo(placeName)
        }
        
        let screenWidth = UIScreen.main.bounds.width
        
        view.addSubview(foodImageView)
        foodImageView.snp.makeConstraints {
            $0.top.equalTo(menuName.snp.bottom).offset(20)
            $0.leading.equalTo(placeName)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(screenWidth - 40)
        }
    }
    
    func getDatabase() {
        ref.observeSingleEvent(of: .value) { snapshot in
            let dic = snapshot.value as! [String: [String: Any]]
            for index in dic {
                if index.key.contains("-") {
                    self.placeName.text = (index.value["place_name"] as! String)
                    self.menuName.text = (index.value["menu_name"] as! String)
                    
                    // 이미지
                    self.storage.reference(forURL: "gs://goodrestaurantstorage.appspot.com/\(index.key)").downloadURL { (url, error) in
                        if let error = error {
                            Log.error(error.localizedDescription)
                        } else {
                            let data = NSData(contentsOf: url!)
                            let image = UIImage(data: data! as Data)
                            self.foodImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    @objc func dlAction() {
        testLabel.isHidden = false
    }
    
    func createDynamicLink() {
        let link = URL(string: "https://goodrestaurantstorage.page.link/OpenEvent?eventId=1")
        let referralLink = DynamicLinkComponents(link: link!, domainURIPrefix: "https://goodrestaurantstorage.page.link")
        
        // iOS 설정
        referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.appg.standard.bankdiary-client")
        referralLink?.iOSParameters?.minimumAppVersion = "1.0"
        referralLink?.iOSParameters?.appStoreID = "1543640471"
//        referralLink?.iOSParameters?.customScheme = "커스텀 스키마가 설정되어 있을 경우 추가"
        
        // 단축 URL 생성
        referralLink?.shorten { (shortURL, warnings, error) in
            if let error = error {
                Log.error(error.localizedDescription)
                return
            }
            Log.info(shortURL!)
        }
        
        Log.info("url", referralLink?.url ?? "")
    }
}
