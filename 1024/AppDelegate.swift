//
//  AppDelegate.swift
//  1024
//
//  Created by zhoucj on 2018/5/29.
//  Copyright © 2018年 zhoucj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController(rootViewController: MainViewController())
        //设置导航栏颜色
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        nav.navigationBar.barTintColor = getDarkModeBGColor(UIColor(displayP3Red: 0, green: 117/255, blue: 131/255, alpha: 1), darkColor: nil)
        nav.navigationBar.tintColor = UIColor.white
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

