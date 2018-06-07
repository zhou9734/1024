//
//  String+Extension.swift
//  1024
//
//  Created by zhoucj on 2018/6/3.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit

extension String{
    //根据开始位置和长度截取字符串
    func subString(start:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
}
