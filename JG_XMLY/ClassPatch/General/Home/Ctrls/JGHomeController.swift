//
//  JGHomeController.swift
//  JG_XMLY
//
//  Created by 郭军 on 2019/4/20.
//  Copyright © 2019 guojun. All rights reserved.
//

import UIKit
import DNSPageView


class JGHomeController: JGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func configUI() {
        
        let style = DNSPageStyle()
        style.isTitleScaleEnabled = true
        style.isTitleViewScrollEnabled = false
        style.isShowBottomLine = true
        style.titleSelectedColor = UIColor.black
        style.titleColor = UIColor.gray
        style.bottomLineColor = JGButtonColor
        style.bottomLineHeight = 2
        
        let titles = ["推荐","分类","VIP","直播","广播"]
        let Ctrls:[UIViewController] = [JGHomeRecommendController(),JGHomeClassifyController(),JGHomeVIPController(),JGHomeLiveController(),JGHomeBroadcastController()]
        
        let pageView = DNSPageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - JGTabBarHeight - JGNavBarHeight), style: style, titles: titles, childViewControllers: Ctrls)
        pageView.contentView.backgroundColor = UIColor.white
        view.addSubview(pageView)
    }
    
    
    
    
    
}
