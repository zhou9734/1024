//
//  BlockModel.swift
//  1024
//
//  Created by zhoucj on 2018/5/31.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit

class BlockModel: NSObject {
    //标题
    var title: String = ""
    //发帖人
    var createUser: String = ""
    //最后回帖人
    var lastReply: String = ""
    //地址
    var url: String = ""
    var doubleLine: Bool = false
    
    override init() {
        super.init()
    }
}
