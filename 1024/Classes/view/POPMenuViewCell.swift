//
//  POPMenuViewCell.swift
//  1024
//
//  Created by zcj on 2020/5/1.
//  Copyright © 2020 zhoucj. All rights reserved.
//
import UIKit
import SnapKit

class POPMenuViewCell: UITableViewCell {
    lazy var imgView:UIImageView = UIImageView()
    lazy var titleLabel:UILabel = UILabel()
    lazy var separtorLine:UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.textColor = UIColor(displayP3Red: 128/255, green: 137/255, blue: 137/255, alpha: 1)
        titleLabel.textAlignment = .center
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.separtorLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        self.imgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(self.imgView.snp.height)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right)
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(5)
        }
        self.separtorLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(1)
        }
    }
}
