//
//  LSReplyCell.swift
//  LoveStory
//
//  Created by songlong on 2017/2/6.
//  Copyright © 2017年 com.Saber. All rights reserved.
//

import UIKit

class LSReplyCell: UITableViewCell {

    private var iconView = UIImageView()
    private var timeLabel = UILabel()
    private var contentLabel = UILabel()
    
    
    var replyModel: LSReplyModel? {
        didSet {
            contentLabel.text = replyModel?.content
            timeLabel.text = replyModel?.time
            iconView.sd_setImage(with: URL(string: (replyModel?.avator_url)!))
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
        
    
        
        contentView.addSubview(tempView)
        tempView.addSubview(iconView)
        tempView.addSubview(timeLabel)
        tempView.addSubview(contentLabel)
        
        
        tempView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(contentView)
            make.top.equalTo(1)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(15)
            make.left.equalTo(30)
        }
        
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.preferredMaxLayoutWidth = LSWidth - 90
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(15)
            make.top.equalTo(iconView)
        }
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .lightGray
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView.snp.bottom)
            make.left.equalTo(iconView.snp.right).offset(15)
            make.bottom.equalTo(-15)
        }
    }


}
