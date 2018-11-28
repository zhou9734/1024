//
//  ViewController.swift
//  1024
//
//  Created by zhoucj on 2018/5/29.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import SwiftSoup

class MainViewController: UIViewController{
    fileprivate var dataCell: [[ConfModel]] = [[ConfModel]]()
    fileprivate var enjoyCell: [ConfModel]?
    fileprivate var movieCell: [ConfModel]?
    fileprivate let identifier = "tableIdentifier"
    let header:[String] = ["草榴休閑區", "电影区"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupUI()
    }
    
    fileprivate func setupUI() {
        self.title = "草榴社區"
        self.view.addSubview(self.tbl)
        self.tbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.leftBtn)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    fileprivate func initData(){
        enjoyCell = ConfModel.loadData(fileName: "enjoy")
        movieCell = ConfModel.loadData(fileName: "movie")
        dataCell.append(enjoyCell!)
        dataCell.append(movieCell!)
    }
    
    fileprivate lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("回家", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(MainViewController.reback), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    fileprivate lazy var tbl: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .plain)
        tv.register(MainTableCell.self, forCellReuseIdentifier: identifier)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    @objc fileprivate func reback(){
        SVProgressHUD.showInfo(withStatus: "获取地址中...")
        NetworkTool.sharedInstance.getHomeUrl(){ (url) in
            let rootUrl = "http://" + url! + "/"
            CommonTools.setUrl(url: rootUrl)
            SVProgressHUD.dismiss()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension MainViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataCell.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCell[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MainTableCell
        let cellData = dataCell[indexPath.section][indexPath.row]
        cell.cellData = cellData
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
}
extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //释放选中效果
        tableView.deselectRow(at: indexPath, animated: true)
        let cellData = dataCell[indexPath.section][indexPath.row]
        let blockVC = BlockViewController()
        blockVC.confiModel = cellData
        self.navigationController?.pushViewController(blockVC, animated: true)
    }
}

