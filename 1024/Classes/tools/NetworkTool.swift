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
    
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    //发送get请求
    func getRequest(urlString: String, params : [String : Any], finished : @escaping (_ response : String?,_ error:Error?)->()) {
        let urlStr = rootUrl + urlString
        NetworkTool.sharedSessionManager.request(urlStr).response { response in // method defaults to `.get`
            if response.error != nil{
                finished(nil, response.error)
            }else{
                if let data = response.data{
                    let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
                    let str : String = NSString(data: data, encoding: enc)! as String
                    finished(str, nil)
                }else{
                    finished(nil, response.error)
                }
            }
        }
//        do{
//            let urlStr = rootUrl + urlString
//            let url = URL(string: urlStr)!
//            let data = try Data(contentsOf: url)
//            let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
//            let str : String = NSString(data: data, encoding: enc)! as String
//            finished(str, nil)
//        }catch{
//            finished(nil, error)
//            CJLog(message: error)
//        }
    }
}
