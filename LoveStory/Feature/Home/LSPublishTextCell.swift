//
//  LSPublishTextCell.swift
//  LoveStory
//
//  Created by songlong on 2017/2/3.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class LSPublishTextCell: UITableViewCell {
    
    private var iconView = UIImageView()
    private var timeLabel = UILabel()
    private var contentLabel = UILabel()
    private var countLabel = UILabel()
    
    var publishModel: PublishModel? {
        didSet {
            contentLabel.text = publishModel?.content
            timeLabel.text = publishModel?.time
            iconView.sd_setImage(with: URL(string: (publishModel?.avator_url)!))
//            if (publishModel?.reply_count)! > 0 {
                countLabel.text = "回复: \((publishModel?.reply_count)!)"
//            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let tempView = UIView()
        tempView.backgroundColor = .white
        
        iconView.layer.cornerRadius = 15
        iconView.layer.masksToBounds = true
        
        countLabel.textColor = .black
        countLabel.font = UIFont.systemFont(ofSize: 12)
        
        contentView.addSubview(tempView)
        tempView.addSubview(iconView)
        tempView.addSubview(timeLabel)
        tempView.addSubview(contentLabel)
        tempView.addSubview(countLabel)
        
        tempView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(10)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.top.equalTo(15)
        }
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .lightGray
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(15)
        }
        
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        contentLabel.preferredMaxLayoutWidth = LSWidth - 30
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.bottom.equalTo(-20)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(timeLabel)
        }
    }

}
