//
//  JGTabBarController.swift
//  JG_XMLY
//
//  Created by 郭军 on 2019/4/20.
//  Copyright © 2019 guojun. All rights reserved.
//

import UIKit

class JGTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        
        //创建子控制器
        setUpCtrls()
        
    }
    
    /// 创建子控制器
    func setUpCtrls() {
        

        ///首页
        addChildViewController(JGHomeController(), title: "首页", image: "home", selImage: "home_1")
        
        ///我听
        addChildViewController(JGListenController(), title: "我听", image: "find", selImage: "find_1")
        
        ///播放
        addChildViewController(JGPlayController(), title: "", image: "tab_play", selImage: "tab_play")
        
        ///发现
        addChildViewController(JGFindController(), title: "发现", image: "favor", selImage: "favor_1")
        
        ///我的
        addChildViewController(JGMineController(), title: "我的", image: "me", selImage: "me_1")
    }
    
    
    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - VC: 子控制器
    ///   - title: 子控制器标题
    ///   - image: 正常状态下的图片
    ///   - selImage: 选中状态下的图片
    func addChildViewController(_ VC:UIViewController, title:String?, image:String?, selImage:String?) {
        
        VC.title = title
        var NorImg = UIImage.init(named: image!)?.imageWithColor(color: UIColor.hex(hexString: "EC836C"))
        let SelImg = UIImage.init(named: selImage!)?.imageWithColor(color: UIColor.hex(hexString: "FE492A"))
        
        if title!.count == 0 {
            NorImg = UIImage.init(named: image!)?.imageWithColor(color: UIColor.hex(hexString: "FE492A"))
            VC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        }
        
        VC.tabBarItem = UITabBarItem(title: title, image: NorImg?.withRenderingMode(.alwaysOriginal), selectedImage: SelImg?.withRenderingMode(.alwaysOriginal))
        VC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.hex(hexString: "EC836C")], for:.normal)
        VC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.hex(hexString: "FE492A")], for:.selected)

//        if UIDevice.current.userInterfaceIdiom == .phone {
////            VC.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -6, right: 0)
//        }
        addChild(JGBaseNavigationController(rootViewController: VC))
    }
    
    
    
    
}
