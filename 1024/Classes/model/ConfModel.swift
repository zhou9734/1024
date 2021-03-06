//
//  cell.swift
//  1024
//
//  Created by zhoucj on 2018/5/29.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit

class ConfModel: NSObject {
    //图标
    var icon: String?
    //标题
    var title: String?
    //二级标题
    var subTitle: String?
    //链接
    var url: String?
    //主题数量
    var topicCount: String = "0"
    //文章数量
    var articleCount: String = "0"
    
    override init() {
        super.init()
    }
    init(icon: String, title: String, subTitle: String, url: String) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.url = url
    }
    
    init(title: String, subTitle: String, url: String, topicCount: String, articleCount: String){
        self.title = title
        self.subTitle = subTitle
        self.url = url
        self.topicCount = topicCount;
        self.articleCount = articleCount;
    }
    
    static func loadData(fileName: String) -> [ConfModel]{
        let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        guard let filepath = path else {
            return [ConfModel]()
        }
        let dict = NSArray(contentsOfFile: filepath)!
        var cells = [ConfModel]()
        for i in 0..<dict.count {
            let dict = dict[i] as! [String: String]
            let cell = ConfModel()
            cell.icon = dict["icon"]
            cell.title = dict["title"]
            cell.subTitle = dict["subTitle"]
            cell.url = dict["url"]
            cell.topicCount = dict["topicCount"] ?? "0"
            cell.articleCount = dict["articleCount"] ?? "0"
            cells.append(cell)
        }
        return cells
    }
    
}
