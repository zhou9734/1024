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
    var header = "<!DOCTYPE html><html lang=\"en\"><head><title></title><meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,user-scalable=no,viewport-fit=cover\"><meta name=\"format-detection\" content=\"telephone=no\"><meta name=\"apple-mobile-web-app-capable\" content=\"yes\"><link rel=\"stylesheet\" href=\"http://www.viidii.info/web/mob_style.css?v=2.0233\" type=\"text/css\"><style type=\"text/css\" abt=\"234\"></style></head><body "
    var header2 = " ><div style=\"padding:15px;\" class=\"f18\">"
    let footer = "</body></html>"
    var blockModel: BlockModel?{
        didSet{
            if let data = blockModel{
                header2 = header2 + data.title + "</div> <div style=\"margin:0 0 20px 0;height: 1px;transform: scaleY(0.333333);background: #cccccc;\"></div><div class=\"tpc_cont\" style=\"padding:15px 15px 0px 15px;clear:both;\">"
                getPageData(urlStr: data.url)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "草榴社區"
        SVProgressHUD.setDefaultMaskType(.black)
        self.view.addSubview(containerWV)
        containerWV.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    fileprivate lazy var containerWV: WKWebView  = {
        let conf = WKWebViewConfiguration()
        conf.allowsInlineMediaPlayback = true
        let wv = WKWebView(frame: CGRect.zero, configuration: conf)
        wv.isOpaque = false
        wv.scrollView.backgroundColor = getDarkModeBGColor(UIColor(displayP3Red: 247/255, green: 252/255, blue: 236/255, alpha: 1), darkColor: nil)
        //滚动流畅
        wv.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        wv.navigationDelegate = self
        return wv
    }()
    
    //获取页面数据
    fileprivate func getPageData(urlStr: String) {
        SVProgressHUD.show()
        NetworkTool.sharedInstance.getRequest(urlString: urlStr, params: [String: AnyObject]()) { (result,error) in
            if error != nil || result == nil{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "网络错误,请重新打开")
                self.navigationController?.popViewController(animated: true)
                return
            }
            let doc: Document = try! SwiftSoup.parse(result!)
            var containerDivStr = try! doc.select("div[class=tpc_content do_not_catch]").html()
            if "" == containerDivStr{
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "网络错误,请重新打开")
                self.navigationController?.popViewController(animated: true)
                return
            }
            containerDivStr = containerDivStr.replacingOccurrences(of: "data-src", with: "src")
            containerDivStr = self.header + self.bodyColor() + self.header2 + containerDivStr + "</div>" + self.footer
            self.containerWV.loadHTMLString(containerDivStr, baseURL: nil)
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func bodyColor() -> String{
        var bodyColor = ""
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark{
                bodyColor = " style=\"background-color: #1E1E1E;-webkit-text-fill-color: #F8F8FF;\" "
            } else {
                bodyColor = " style=\"background-color: #F9F9EC;-webkit-text-fill-color: #5E5E5E;\" "
            }
        }
        return bodyColor
    }
    
    fileprivate func changeColor(){
        if #available(iOS 13.0, *) {
           if self.traitCollection.userInterfaceStyle == .dark{
               self.changeTextBackgroundStyle(style: "dark")
           } else {
               self.changeTextBackgroundStyle(style: "light")
           }
       }
    }
    
    fileprivate func changeTextBackgroundStyle(style : String = "dark"){
        if style == "dark" {
            //字体颜色
            self.containerWV.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#F8F8FF'", completionHandler: nil)
            //背景颜色
            self.containerWV.evaluateJavaScript("document.body.style.backgroundColor=\"#1E1E1E\"", completionHandler: nil)
        }else{
            self.containerWV.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#5E5E5E'", completionHandler: nil)
            self.containerWV.evaluateJavaScript("document.body.style.backgroundColor=\"#F9F9EC\"", completionHandler: nil)
        }
    }
}

extension ContentViewController: WKNavigationDelegate{
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        SVProgressHUD.dismiss()
        changeColor()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            //判断模式
            if traitCollection.userInterfaceStyle == .dark {
                changeTextBackgroundStyle(style: "dark")
            }else {
                changeTextBackgroundStyle(style: "light")
           }
       }
    }
}

