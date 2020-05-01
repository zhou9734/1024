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
    //数组用于添加菜单选项
    lazy var menuArr:[PopMenu] = [PopMenu]()
    lazy var menuView:POPMenuView = POPMenuView()
    
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
        addRightBtn()
    }
    
    fileprivate func initData(){
        enjoyCell = ConfModel.loadData(fileName: "enjoy")
        movieCell = ConfModel.loadData(fileName: "movie")
        dataCell.append(enjoyCell!)
        dataCell.append(movieCell!)
    }
    
    fileprivate func addRightBtn(){
        let rightBtnItem = UIBarButtonItem(image: UIImage(named: "menu"), landscapeImagePhone: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.rightBtnClick))
        self.navigationItem.rightBarButtonItem = rightBtnItem
        createMenuArr()
    }
    
    func createMenuArr(){
        self.menuArr.append(PopMenu(icon: "setting", title: "设置地址"))
        self.menuArr.append(PopMenu(icon: "setting", title: "设置默认"))
    }
    
    fileprivate lazy var tbl: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .plain)
        tv.register(MainTableCell.self, forCellReuseIdentifier: identifier)
        tv.dataSource = self
        tv.delegate = self
        tv.backgroundColor = getDarkModeBGColor(UIColor(displayP3Red: 247/255, green: 252/255, blue: 236/255, alpha: 1), darkColor: nil)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    @objc func rightBtnClick(){
        self.menuView = POPMenuView.initWith(dataArray: self.menuArr, origin: CGPoint.init(x: SCREEN_WIDTH - 20, y: 100), size: CGSize.init(width: 130, height: 44), direction: POPMenueDirection.right)
        self.menuView.delegate = self
        self.menuView.pop()
    }
    
    internal func POPMenuViewDidSelectedAt(index: Int) {
        print("点击了第\(index)个")
        switch index {
            case 0:
                popSettingUrl()
                break
            case 1:
                CommonTools.setUrl(url: "http://www.t66y.com/")
                break
            default: break
        }
        self.menuView.dismiss()
    }
    
    fileprivate func popSettingUrl(){
        let alertController = UIAlertController(title: "修改地址", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "请输入地址"
            // 添加监听代码，监听文本框变化时要做的操作
            NotificationCenter.default.addObserver(self, selector: #selector(self.alertTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        })
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.default , handler: { (action: UIAlertAction!) -> Void in
            let okText = (alertController.textFields?.first)! as UITextField
            var url = "http://www.t66y.com/";
            if let str = okText.text {
                url = str
            }
            CJLog(message: url)
            CommonTools.setUrl(url: url)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        })
        okAction.isEnabled = false
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// 监听文字改变
    @objc func alertTextFieldDidChange(){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let login = (alertController!.textFields?.first)! as UITextField
            let okAction = alertController!.actions.last! as UIAlertAction
            if (!(login.text?.isEmpty)!) {
                okAction.isEnabled = true
            } else {
                okAction.isEnabled = false
            }
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

extension MainViewController: POPMenuViewDelegate{
   
}

