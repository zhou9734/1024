//
//  NoNetwork.swift
//  1024
//
//  Created by zhoucj on 2018/6/10.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
import SnapKit

class NoNetworkView: UIView {
    var delege: NoNetworkProtocal?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgV)
        addSubview(btnLoad)
        imgV.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-50)
        }
        btnLoad.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(25)
            make.centerX.equalTo(self)
            make.top.equalTo(self.imgV.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var imgV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "picture_nointernet_night")
        return iv
    }()
    
    fileprivate lazy var btnLoad: UIButton = {
        let btn = UIButton()
        btn.setTitle("马上重试", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = getDarkModeBGColor(UIColor.orange, darkColor: UIColor(displayP3Red: 28/255, green: 27/255, blue: 32/255, alpha: 1))
        btn.addTarget(self, action: #selector(NoNetworkView.reloadData), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func reloadData(){
        delege?.reload()
    }
}
