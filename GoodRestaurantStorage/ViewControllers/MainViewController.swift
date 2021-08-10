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
import RxCocoa
import RxSwift
import JGProgressHUD

class MainViewController: UIViewController {
    
    let ref = Database.database().reference()
    let storage = Storage.storage()
    let bag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    var placeName: [String] = []
    var menuName: [String] = []
    var review: [String] = []
    var foodImageUrl: [URL] = []
    
    
    var testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "성공"
        lb.isHidden = true
        return lb
    }()
    
    let postTableView = UITableView()
    
    lazy var hud: JGProgressHUD = {
        let loader = JGProgressHUD(style: .dark)
        loader.textLabel.text = "Loading"
        return loader
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createDynamicLink()
//        NotificationCenter.default.addObserver(self, selector: #selector(dlAction), name: Notification.Name(rawValue: "clickFirebaseDynamicLink"), object: nil)
        
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "cell")
        
        refreshControl.endRefreshing()
        postTableView.refreshControl = refreshControl
        
        setupUI()
        getDatabase()
        setupReload()
        
        hud.show(in: view, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.postTableView.reloadData()
            self.hud.dismiss(animated: true)
        }
    }
    
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(testLabel)
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        view.addSubview(postTableView)
        postTableView.allowsSelection = false
        postTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    
    func getDatabase() {
        ref.observeSingleEvent(of: .value) { snapshot in
            let dic = snapshot.value as! [String: [String: Any]]
            let postDic = dic["post"] as! [String: [String: Any]]
            
            for index in postDic {
                self.placeName.append(index.value["place_name"] as! String)
                self.menuName.append(index.value["menu_name"] as! String)
                self.review.append(index.value["review"] as! String)
                
                // 이미지
                self.storage.reference(forURL: "gs://goodrestaurantstorage.appspot.com/\(index.key)").downloadURL { (url, error) in
                    if let error = error {
                        Log.error(error.localizedDescription)
                    } else {
                        self.foodImageUrl.append(url!)
                    }
                }
            }
        }
    }
    
    func setupReload() {
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { _ in
                
                self.placeName.removeAll()
                self.menuName.removeAll()
                self.review.removeAll()
                self.foodImageUrl.removeAll()
                
                self.getDatabase()
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
                    self!.refreshControl.endRefreshing()
                    self!.postTableView.reloadData()
                }
            }).disposed(by: bag)
    }
}


//MARK: - UITableView
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PostTableViewCell
        cell.placeNameLabel.text = placeName[indexPath.row]
        cell.menuNameLabel.text = menuName[indexPath.row]
        cell.reviewLabel.text = review[indexPath.row]
        let data = NSData(contentsOf: foodImageUrl[indexPath.row])
        let image = UIImage(data: data! as Data)
        cell.foodImageView.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.screenWidth + 120
    }
}
