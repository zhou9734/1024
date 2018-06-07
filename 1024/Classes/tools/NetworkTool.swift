//
//  NetworkTool.swift
//  1024
//
//  Created by zhoucj on 2018/6/3.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
import Alamofire

class NetworkTool: NSObject {
    let rootUrl = CommonTools.getDefaultUrl()
    
    static let sharedInstance: NetworkTool = {
        let tool = NetworkTool()
        return tool
    }()
    //发送get请求
    func getRequest(urlString: String, params : [String : Any], finished : @escaping (_ response : String?,_ error:Error?)->()) {
        do{
            let urlStr = rootUrl + urlString
            let url = URL(string: urlStr)!
            let data = try Data(contentsOf: url)
            let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
            let str : String = NSString(data: data, encoding: enc)! as String
            finished(str, nil)
        }catch{
            CJLog(message: error)
        }
    }
}
