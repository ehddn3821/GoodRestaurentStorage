//
//  PostTableViewCell.swift
//  GoodRestaurantStorage
//
//  Created by 앱지 Appg on 2021/08/09.
//

import UIKit
import SnapKit

class PostTableViewCell: UITableViewCell {
    
    var foodImageView = UIImageView()
    var placeNameLabel = UILabel()
    var menuNameLabel = UILabel()
    var reviewLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        contentView.addSubview(placeNameLabel)
        placeNameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(20)
        }
        
        contentView.addSubview(menuNameLabel)
        menuNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(20)
            $0.leading.equalTo(placeNameLabel)
        }
        
        contentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(menuNameLabel.snp.bottom).offset(20)
            $0.leading.equalTo(placeNameLabel)
        }
        
        contentView.addSubview(foodImageView)
        foodImageView.contentMode = .scaleAspectFit
        foodImageView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(20)
            $0.leading.equalTo(placeNameLabel)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(Constants.screenWidth - 40)
        }
    }
    
    
}
