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
                iconIv.image = UIImage(named: _cellData.icon!)
                titleLbl.text = _cellData.title!
                subTitleLbl.text = _cellData.subTitle! + "\n";
                url = _cellData.url!
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
        self.contentView.addSubview(iconIv)
        self.contentView.addSubview(titleLbl)
        self.contentView.addSubview(subTitleLbl)
        iconIv.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.left.equalTo(self.contentView.snp.left).offset(5)
            make.top.equalTo(self.contentView.snp.top)
        }
        titleLbl.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(iconIv.snp.right).offset(5)
            make.top.equalTo(self.contentView.snp.top).offset(15)
            make.right.equalTo(self.contentView.snp.right)
        }
        subTitleLbl.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.right.equalTo(self.contentView.snp.right)
            make.top.equalTo(titleLbl.snp.bottom)
            make.left.equalTo(titleLbl.snp.left)
        }
    }
    
    fileprivate lazy var iconIv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    fileprivate lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.black
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate lazy var subTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.gray
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byClipping
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
}
