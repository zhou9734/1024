//
//  BlockViewController.swift
//  1024
//
//  Created by zhoucj on 2018/5/31.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import SVProgressHUD
import SwiftSoup

class BlockViewController: UIViewController {
    let blockCellIdentifier = "blockCellIdentifier"
    var blockModels: [BlockModel] = [BlockModel]()
    var url: String = ""
    var confiModel: ConfModel?{
        didSet{
            if let _conf = confiModel{
                self.title = _conf.title
                self.url = _conf.url!
                self.page = 2
            }
        }
    }
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    //下拉加载
    let footer = MJRefreshBackNormalFooter()
    var page = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    fileprivate func setupUI(){
        self.view.addSubview(tbl)
        tbl.estimatedRowHeight = 70.0
        tbl.rowHeight = UITableViewAutomaticDimension
        tbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        header.setRefreshingTarget(self, refreshingAction: #selector(self.loadData))
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.loadMore))
        tbl.mj_header = header
        tbl.mj_footer = footer
        tbl.mj_header.beginRefreshing()
    }
    //下拉刷新
    @objc fileprivate func loadData(){
        NetworkTool.sharedInstance.getRequest(urlString: url, params: [String: AnyObject]()) { (result,error) in
            self.blockModels = self.getBlockData(response: result!)
            self.tbl.reloadData();
            self.tbl.mj_header.endRefreshing()
            self.page = 2
        }
    }
    
    //下拉加载
    @objc fileprivate func loadMore(){
        NetworkTool.sharedInstance.getRequest(urlString: url + "&search=&page=\(page)", params: [String: AnyObject]()) { (result,error) in
            let tmpBlockModels = self.getBlockData(response: result!)
            tmpBlockModels.forEach({ (b) in
                self.blockModels.append(b)
            })
            self.tbl.reloadData();
            self.tbl.mj_header.endRefreshing()
            self.page = self.page + 1
        }
    }
    
    fileprivate lazy var tbl: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .plain)
        tv.register(BlockListTableCell.self, forCellReuseIdentifier: blockCellIdentifier)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    @objc fileprivate func backFunc(){
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func getBlockData(response: String) -> [BlockModel]{
        var blockList = [BlockModel]()
        let doc: Document = try! SwiftSoup.parse(response)
        let trs = try! doc.select("tr[class=tr3 t_one tac]")
        var count = 0
        for tr in trs{
            if count < 9{
                count = count + 1
                continue
            }
            let url = try! tr.select("h3").first()?.select("a").attr("href")
            let title = try! tr.select("h3").first()?.select("a").text()
            let createUser = try! tr.select("a[class=bl]").first()?.text()
            let createDate = try! tr.select("span[class=s3]").first()?.text()
            let lastReplyDate = try! tr.select("a[class=bl]").first()?.nextElementSibling()?.text()
            let lastReply  = try! tr.select("a[class=bl]").first()?.text()
            let model = BlockModel()
            if let url = url{
                model.url = url
            }
            if let title = title{
                model.title = title
            }
            if let createUser = createUser {
                if let createDate = createDate{
                    model.createUser = createUser + createDate
                }
            }
            if let lastReplyDate = lastReplyDate{
                if let lastReply = lastReply{
                    model.lastReply = "最后回帖: " + lastReplyDate + lastReply
                }
            }
            blockList.append(model)
        }
        return blockList
    }
    override func didReceiveMemoryWarning() {
    }
}

extension BlockViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: blockCellIdentifier, for: indexPath) as! BlockListTableCell
        let cellData = blockModels[indexPath.row]
        cell.blockModel = cellData
        return cell
    }
}
extension BlockViewController: UITableViewDelegate{
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //释放选中效果
        tableView.deselectRow(at: indexPath, animated: true)
        //let cellData = dataCell[indexPath.section][indexPath.row]
    }
}
