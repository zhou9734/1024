//
//  POPMenuView.swift
//  1024
//
//  Created by zcj on 2020/5/1.
//  Copyright © 2020 zhoucj. All rights reserved.
//

import UIKit
//代理方法，选中事件
protocol POPMenuViewDelegate {
    func POPMenuViewDidSelectedAt(index:Int)
}

enum POPMenueDirection {
    case left
    case right
}

class POPMenuView: UIView{
    var delegate:POPMenuViewDelegate?
    var font:UIFont = UIFont.boldSystemFont(ofSize: 14)
    var direction:POPMenueDirection = POPMenueDirection.left
    var menuArr:[PopMenu] = [PopMenu](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var orign:CGPoint = CGPoint.zero
    var cellHeight:CGFloat = 44
    //分割线颜色
    var separtorColor:UIColor = UIColor.gray
    
    var textColor:UIColor = UIColor(displayP3Red: 128/255, green: 137/255, blue: 137/255, alpha: 1)
    
    lazy var tableView:UITableView = {
        let tabV = UITableView(frame: CGRect.zero, style: .plain)
//        tabV.backgroundColor = UIColor(displayP3Red: 73/255, green: 71/255, blue: 75/255, alpha: 1)
        tabV.backgroundColor = getDarkModeBGColor(UIColor.white, darkColor: UIColor(displayP3Red: 73/255, green: 71/255, blue: 75/255, alpha: 1))
        tabV.bounces = false
        tabV.layer.cornerRadius = 5
        tabV.delegate = self
        tabV.dataSource = self
        tabV.register(POPMenuViewCell.self, forCellReuseIdentifier: "menuCell")
        return tabV
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func InitUI(){
        self.addSubview(self.tableView)
        tableView.tableFooterView = UIView()
        
    }
    //创建
    static func initWith(dataArray:[PopMenu], origin:CGPoint, size: CGSize, direction:POPMenueDirection) -> POPMenuView{
        let menuView = POPMenuView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        menuView.direction = direction
        menuView.orign = origin
        menuView.cellHeight = size.height
        menuView.backgroundColor = UIColor.clear
        
        if direction == POPMenueDirection.left {
            menuView.tableView.frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height*CGFloat(dataArray.count))
        }else{
            menuView.tableView.frame = CGRect(x: origin.x, y: origin.y, width: -size.width, height: size.height*CGFloat(dataArray.count))
        }
        menuView.InitUI()
        menuView.menuArr = dataArray
        menuView.pop()
        
        return menuView
    }
    
    func pop(){
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        let frame = self.tableView.frame
        self.tableView.frame = CGRect(x: orign.x, y: orign.y, width: 0, height: 0)
        UIView.animate(withDuration: 0.2) {
            self.tableView.frame = frame
        }
    }
    func dismiss(){
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.frame = CGRect(x: self.orign.x, y: self.orign.y, width: 0, height: 0)
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        if self.direction == POPMenueDirection.left {
            let startX = self.orign.x + 20
            let startY = self.orign.y
            context?.move(to: CGPoint(x: startX, y: startY))//起点
            context?.addLine(to: CGPoint(x: startX+5, y: startY-8))
            context?.addLine(to: CGPoint(x: startX+10, y: startY))
        }else{
            let startX = self.orign.x - 20
            let startY = self.orign.y
            context?.move(to: CGPoint(x: startX, y: startY))//起点
            context?.addLine(to: CGPoint(x: startX+5, y: startY-8))
            context?.addLine(to: CGPoint(x: startX+10, y: startY))
        }
        context?.closePath()//结束
        self.tableView.backgroundColor?.setFill()//设置填充色
        self.tableView.backgroundColor?.setStroke()
        context?.drawPath(using: .fillStroke)//绘制路径
    }
    
}

extension POPMenuView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! POPMenuViewCell
        let menu = self.menuArr[indexPath.row]
        cell.imgView.image = UIImage(named: menu.icon)
        cell.titleLabel.text = menu.title
        cell.titleLabel.font = font
        cell.titleLabel.textColor = textColor
        cell.separtorLine.isHidden = (indexPath.row < menuArr.count - 1) ? false : true
        cell.separtorLine.backgroundColor = separtorColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.POPMenuViewDidSelectedAt(index: indexPath.row)
    }
   
}
