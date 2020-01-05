//
//  TableCell.swift
//  1024
//
//  Created by zhoucj on 2018/5/29.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
import SnapKit

class MainTableCell: UITableViewCell {
    var cellData: ConfModel?{
        didSet{
            if let _cellData = cellData{
//                iconIv.image = UIImage(named: _cellData.icon!)
                self.titleLbl.text = _cellData.title!
                self.subTitleLbl.text = _cellData.subTitle!;
                self.url = _cellData.url!
                self.topicLbl.text = "主题: \(_cellData.topicCount) 文章: \(_cellData.articleCount)"
            }
        }
    }
    var url: String = ""
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        self.contentView.backgroundColor = getDarkModeBGColor(UIColor(displayP3Red: 247/255, green: 252/255, blue: 236/255, alpha: 1), darkColor: nil)
//        self.contentView.addSubview(iconIv)
        self.contentView.addSubview(self.titleLbl)
        self.contentView.addSubview(self.subTitleLbl)
        self.contentView.addSubview(self.topicLbl)
//        iconIv.snp.makeConstraints { (make) in
//            make.width.height.equalTo(60)
//            make.left.equalTo(self.contentView.snp.left).offset(5)
//            make.top.equalTo(self.contentView.snp.top)
//        }
        self.titleLbl.snp.makeConstraints { (make) in
//            make.height.equalTo(20)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.right.equalTo(self.contentView.snp.right)
        }
        self.subTitleLbl.snp.makeConstraints { (make) in
//            make.height.equalTo(35)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.titleLbl.snp.bottom).offset(3)
            make.left.equalTo(self.contentView.snp.left).offset(13)
        }
        self.topicLbl.snp.makeConstraints { (make) in
//            make.height.equalTo(20)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(self.subTitleLbl.snp.bottom).offset(3)
            make.left.equalTo(self.contentView.snp.left).offset(10)
        }
    }
    
//    fileprivate lazy var iconIv: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
    
    fileprivate lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = getDarkModeBGColor(UIColor(displayP3Red: 47/255, green: 96/255, blue: 168/255, alpha: 1), darkColor: UIColor.white)
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate lazy var subTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(displayP3Red: 128/255, green: 137/255, blue: 137/255, alpha: 1)
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byClipping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate lazy var topicLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(displayP3Red: 94/255, green: 94/255, blue: 94/255, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
}
