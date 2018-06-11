//
//  ContentViewController.swift
//  1024
//
//  Created by zhoucj on 2018/6/7.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import SwiftSoup
import WebKit
import MJRefresh

class ContentViewController: UIViewController {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var header = "<!DOCTYPE html><html lang=\"en\"><head><title></title><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,user-scalable=no,viewport-fit=cover\"><meta name=\"format-detection\" content=\"telephone=no\"><meta name=\"apple-mobile-web-app-capable\" content=\"yes\"><link rel=\"stylesheet\" href=\"http://www.viidii.info/web/mob_style.css?v=2.0233\" type=\"text/css\"><style type=\"text/css\" abt=\"234\"></style></head><body><div style=\"padding:15px;\" class=\"f18\">"
    let footer = "</body></html>"
    var blockModel: BlockModel?{
        didSet{
            if let data = blockModel{
                header = header + data.title + "</div> <div style=\"margin:0 0 20px 0;height: 1px;transform: scaleY(0.333333);background: #cccccc;\"></div><div class=\"tpc_cont\" style=\"padding:15px 15px 0px 15px;clear:both;\">"
                getPageData(urlStr: data.url)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "草榴社區"
        SVProgressHUD.setDefaultMaskType(.black)
        self.view.backgroundColor = UIColor(displayP3Red: 247/255, green: 252/255, blue: 236/255, alpha: 1)
        self.view.addSubview(containerWV)
        containerWV.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    fileprivate lazy var containerWV: WKWebView  = {
        let wv = WKWebView()
        wv.isOpaque = false
        wv.backgroundColor = UIColor(displayP3Red: 247/255, green: 252/255, blue: 236/255, alpha: 1)
        //滚动流程
        wv.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        return wv
    }()
    
    //获取页面数据
    fileprivate func getPageData(urlStr: String) {
        SVProgressHUD.show()
        NetworkTool.sharedInstance.getRequest(urlString: urlStr, params: [String: AnyObject]()) { (result,error) in
            if error != nil || result == nil{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "网络错误,请重新打开")
                return
            }
            let doc: Document = try! SwiftSoup.parse(result!)
            var containerDivStr = try! doc.select("div[class=tpc_content do_not_catch]").html()
            if "" == containerDivStr{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "网络错误,请重新打开")
                return
            }
            containerDivStr = containerDivStr.replacingOccurrences(of: "data-src", with: "src")
            containerDivStr = self.header + containerDivStr + "</div>" + self.footer
            self.containerWV.loadHTMLString(containerDivStr, baseURL: nil)
            SVProgressHUD.dismiss()
        }
    }
}

