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
import MJRefresh

protocol NoNetworkProtocal {
    func reload()
}

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
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    fileprivate func initData(){
        enjoyCell = ConfModel.loadData(fileName: "enjoy")
        movieCell = ConfModel.loadData(fileName: "movie")
        dataCell.append(enjoyCell!)
        dataCell.append(movieCell!)
    }
    
    fileprivate lazy var tbl: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .plain)
        tv.register(MainTableCell.self, forCellReuseIdentifier: identifier)
        tv.dataSource = self
        tv.delegate = self
//        tv.backgroundColor = getDarkModeBGColor(UIColor(displayP3Red: 247/255, green: 252/255, blue: 236/255, alpha: 1), darkColor: nil)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
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
        return 80
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = getDarkModeBGColor(UIColor(displayP3Red: 178/255, green: 211/255, blue: 225/255, alpha: 1), darkColor: UIColor(displayP3Red: 28/255, green: 27/255, blue: 32/255, alpha: 1))
        let lbl = UILabel()
        lbl.frame = CGRect(x: 10, y: 7, width: 200, height: 15)
        lbl.text = header[section] //UIColor(displayP3Red: 2/255, green: 75/255, blue: 125/255, alpha: 1)
        lbl.textColor = getDarkModeBGColor(UIColor(displayP3Red: 2/255, green: 75/255, blue: 125/255, alpha: 1), darkColor: UIColor.white)
        lbl.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(lbl)
        return view
    }
}

