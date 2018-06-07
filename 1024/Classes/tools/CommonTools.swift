//
//  CommonTools.swift
//  1024
//
//  Created by zhoucj on 2018/5/29.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
class CommonTools {
    static func getDefaultUrl() -> String {
        var url = UserDefaults.standard.string(forKey: "CLURL")
        if url == nil {
            url = "http://www.t66y.com/"
            UserDefaults.standard.set(url, forKey: "CLURL")
        }
        return url!
    }
    
    static func setUrl(url: String?) {
        if url != nil{
            UserDefaults.standard.set(url, forKey: "CLURL")
        }
    }
}

//日志输出
func CJLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    //只有在DEBUG模式下才会打印. 需要在Build Settig中设置
    #if DEBUG
        let index = fileName.index(of: ".") ?? fileName.endIndex
        let _fileName = fileName[..<index]
        print("\(_fileName).\(methodName).[\(lineNumber)]: \(message)")
    #endif
}
//提示框
func alert(msg: String,this: UIViewController){
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: nil, style: .default, handler: nil))
    this.present(alert, animated: true, completion: nil)
}
