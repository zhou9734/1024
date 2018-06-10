//
//  BlockListTableCell.swift
//  1024
//
//  Created by zhoucj on 2018/5/31.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
import SnapKit

class BlockListTableCell: UITableViewCell {
    let width = UIScreen.main.bounds.width/2
    var blockModel: BlockModel?{
        didSet{
            if let data = blockModel{
                titleLbl.text = data.title
                createUserLbl.text = data.createUser
                replyLbl.text = data.lastReply
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        self.contentView.backgroundColor = UIColor(displayP3Red: 247/255, green: 252/255, blue: 236/255, alpha: 1)
        self.contentView.addSubview(titleLbl)
        self.contentView.addSubview(createUserLbl)
        self.contentView.addSubview(replyLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView.snp.top).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        createUserLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(width - 20)
        }
        replyLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(10)
            make.right.equalTo(self.contentView.snp.right)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(width + 20)
        }
    }
    
    fileprivate lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(displayP3Red: 58/255, green: 76/255, blue: 163/255, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 17)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate lazy var createUserLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(displayP3Red: 94/255, green: 94/255, blue: 94/255, alpha: 1)
        return lbl
    }()
    
    fileprivate lazy var replyLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(displayP3Red: 94/255, green: 94/255, blue: 94/255, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .right
        return lbl
    }()
}
