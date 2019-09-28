//
//  JGRecomandViewModel.swift
//  JG_XMLY
//
//  Created by 郭军 on 2019/4/20.
//  Copyright © 2019 guojun. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class JGRecomandViewModel: NSObject {

    // MARK - 数据模型
    var fmhomeRecommendModel:JGHomeRecommendModel?
    var homeRecommendList:[JGRecommendModel]?
    var recommendList : [JGRecommendListModel]?
    var focus:JGFocusModel?
    var squareList:[JGSquareModel]?
    var topBuzzList: [JGTopBuzzModel]?
    var guessYouLikeList: [JGGuessYouLikeModel]?
    var paidCategoryList: [JGPaidCategoryModel]?
    var playlist: JGPlaylistModel?
    var oneKeyListenList: [JGOneKeyListenModel]?
    var liveList: [JGLiveModel]?

    // 穿插的广告数据
     var recommnedAdvertList:[JGRecommnedAdvertModel]?
    
    // Mark: -数据源更新
    typealias AddDataBlock = () ->Void
    var updateDataBlock:AddDataBlock?
    
    typealias AddAdDataBlock = () ->Void
    var updateAdDataBlock:AddAdDataBlock?
}


// MARK: - 获取数据源
extension JGRecomandViewModel {
    
    func refreshDataSource() {
                
        RecommendProvider.request(.recommendList) { result in
            
             if case let .success(response) = result {
             
                //解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let mappedObject = JSONDeserializer<JGHomeRecommendModel>.deserializeFrom(json: json.description) {
                    
                    self.fmhomeRecommendModel = mappedObject
                    self.homeRecommendList = mappedObject.list
                    
                    if let recommendList = JSONDeserializer<JGRecommendListModel>.deserializeModelArrayFrom(json: json["list"].description) {
                        self.recommendList = recommendList as? [JGRecommendListModel]
                    }
                    
                    if let focus = JSONDeserializer<JGFocusModel>.deserializeFrom(json: json["list"][0]["list"][0].description) {
                        self.focus = focus
                    }
                    
                    if let square = JSONDeserializer<JGSquareModel>.deserializeModelArrayFrom(json: json["list"][1]["list"].description) {
                        self.squareList = square as? [JGSquareModel]
                    }
                    if let topBuzz = JSONDeserializer<JGTopBuzzModel>.deserializeModelArrayFrom(json: json["list"][2]["list"].description) {
                        self.topBuzzList = topBuzz as? [JGTopBuzzModel]
                    }
                    
                    if let oneKeyListen = JSONDeserializer<JGOneKeyListenModel>.deserializeModelArrayFrom(json: json["list"][9]["list"].description) {
                        self.oneKeyListenList = oneKeyListen as? [JGOneKeyListenModel]
                    }
                    
                    if let live = JSONDeserializer<JGLiveModel>.deserializeModelArrayFrom(json: json["list"][14]["list"].description) {
                        self.liveList = live as? [JGLiveModel]
                    }
                    self.updateDataBlock?()
                }
            }
        }
    }
    
    
    func setupLoadRecommendAdData() {
        // 首页穿插广告接口请求
        RecommendProvider.request(.recommendAdList) { result in
            if case let .success(response) = result {
                // 解析数据
                let data = try? response.mapJSON()
                let json = JSON(data!)
                if let advertList = JSONDeserializer<JGRecommnedAdvertModel>.deserializeModelArrayFrom(json: json["data"].description) { // 从字符串转换为对象实例
                    self.recommnedAdvertList = advertList as? [JGRecommnedAdvertModel]
                    self.updateAdDataBlock?()
                }
            }
        }
        
    }
    
}


extension JGRecomandViewModel {
    
    func numberOfSections(collectionView:UICollectionView) ->Int {
        return (self.homeRecommendList?.count) ?? 0
    }
    // 每个分区显示item数量
    func numberOfItemsIn(section: NSInteger) -> NSInteger {
        return 1
    }
    //每个分区的内边距
    func insetForSectionAt(section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //最小 item 间距
    func minimumInteritemSpacingForSectionAt(section:Int) ->CGFloat {
        return 0
    }
    
    //最小行间距
    func minimumLineSpacingForSectionAt(section:Int) ->CGFloat {
        return 0
    }
    
    // item 尺寸
    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        let HeaderAndFooterHeight:Int = 90
        let itemNums = (self.homeRecommendList?[indexPath.section].list?.count)!/3
        let count = self.homeRecommendList?[indexPath.section].list?.count
        let moduleType = self.homeRecommendList?[indexPath.section].moduleType
        if moduleType == "focus" {
            return CGSize.init(width:kScreenWidth,height:360)
        }else if moduleType == "square" || moduleType == "topBuzz" {
            return CGSize.zero
        }else if moduleType == "guessYouLike" || moduleType == "paidCategory" || moduleType == "categoriesForLong" || moduleType == "cityCategory" || moduleType == "live"{
            return CGSize.init(width:kScreenWidth,height:CGFloat(HeaderAndFooterHeight+180*itemNums))
        }else if moduleType == "categoriesForShort" || moduleType == "playlist" || moduleType == "categoriesForExplore"{
            return CGSize.init(width:kScreenWidth,height:CGFloat(HeaderAndFooterHeight+120*count!))
        }else if moduleType == "ad" {
            return CGSize.init(width:kScreenWidth,height:240)
        }else if moduleType == "oneKeyListen" {
            return CGSize.init(width:kScreenWidth,height:180)
        }else {
            return .zero
        }
    }
    
    // 分区头视图size
    func referenceSizeForHeaderInSection(section: Int) -> CGSize {
        let moduleType = self.homeRecommendList?[section].moduleType
        if moduleType == "focus" || moduleType == "square" || moduleType == "topBuzz" || moduleType == "ad" || section == 18 {
            return CGSize.zero
        }else {
            return CGSize.init(width: kScreenHeight, height:40)
        }
    }
    
    // 分区尾视图size
    func referenceSizeForFooterInSection(section: Int) -> CGSize {
        let moduleType = self.homeRecommendList?[section].moduleType
        if moduleType == "focus" || moduleType == "square" {
            return CGSize.zero
        }else {
            return CGSize.init(width: kScreenWidth, height: 10.0)
        }
    }
    
    
    
    
    
}
