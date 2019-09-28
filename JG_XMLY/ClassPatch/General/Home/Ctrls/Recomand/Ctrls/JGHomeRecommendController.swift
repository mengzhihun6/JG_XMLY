//
//  JGHomeRecommendController.swift
//  JG_XMLY
//
//  Created by 郭军 on 2019/4/20.
//  Copyright © 2019 guojun. All rights reserved.
//

import UIKit


class JGHomeRecommendController: JGBaseViewController {

    
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.delegate = self
        col.dataSource = self
        col.backgroundColor = UIColor.white
        col.register(cellType: JGRecommendHeaderCell.self)
        col.register(cellType: JGRecommendGuessLikeCell.self)
        col.register(cellType: JGHotAudiobookCell.self)
        col.register(cellType: JGAdvertCell.self)
        col.register(cellType: JGOneKeyListenCell.self)
        col.register(cellType: JGHomeRecommendLiveCell.self)
        col.register(cellType: JGRecommendForYouCell.self)
        col.register(supplementaryViewType: JGRecommendHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        col.register(supplementaryViewType: JGRecommendFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
        col.uHead = URefreshHeader{ [weak self] in self?.loadData() }

        
        return col
    }()
    
    private lazy var viewModel:JGRecomandViewModel = {
        return JGRecomandViewModel()
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        loadData()
    }
    

    override func configUI() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func loadData() {
        
        viewModel.updateDataBlock = { [unowned self] in
            //结束控件刷新
            self.collectionView.uHead.endRefreshing()
        
            DispatchQueue.main.async(execute: {
                //更新数据
                self.collectionView.reloadData()
            })
        }
        viewModel.refreshDataSource()
        
        
        //广告数据
        viewModel.updateAdDataBlock =  { [unowned self] in
            
            DispatchQueue.main.async(execute: {
                //更新数据
                self.collectionView.reloadData()
            })
        }
        viewModel.setupLoadRecommendAdData()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension JGHomeRecommendController:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections(collectionView: collectionView)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsIn(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let moduleType = viewModel.homeRecommendList?[indexPath.section].moduleType

        if moduleType == "focus" || moduleType == "square" || moduleType == "topBuzz" {
           
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGRecommendHeaderCell.self)
            cell.focusModel = viewModel.focus
            cell.squareList = viewModel.squareList
            cell.topBuzzListData = viewModel.topBuzzList
//            cell.delegate = self
            return cell
        }else if moduleType == "guessYouLike" || moduleType == "paidCategory" || moduleType == "categoriesForLong" || moduleType == "cityCategory"{
            // 横式排列布局cell
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGRecommendGuessLikeCell.self)
//            cell.delegate = self
            cell.recommendListData = viewModel.homeRecommendList?[indexPath.section].list
            return cell
        }else if moduleType == "categoriesForShort" || moduleType == "playlist" || moduleType == "categoriesForExplore"{
            // 竖式排列布局cell
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGHotAudiobookCell.self)
//            cell.delegate = self
            cell.recommendListData = viewModel.homeRecommendList?[indexPath.section].list
            return cell
        }else if moduleType == "ad" {
            
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGAdvertCell.self)
            if indexPath.section == 7 {
                cell.adModel = viewModel.recommnedAdvertList?[0]
            }else if indexPath.section == 13 {
                cell.adModel = viewModel.recommnedAdvertList?[1]
                // }else if indexPath.section == 17 {
                // cell.adModel = self.recommnedAdvertList?[2]
            }
            return cell
        }else if moduleType == "oneKeyListen" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGOneKeyListenCell.self)
            cell.oneKeyListenList = viewModel.oneKeyListenList
            return cell
        }else if moduleType == "live" {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGHomeRecommendLiveCell.self)
//            cell.liveList = viewModel.liveList
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: JGRecommendForYouCell.self)
            return cell
        }
    }
    
    // 每个分区的内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return viewModel.insetForSectionAt(section: section)
    }
    
    // 最小item间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumInteritemSpacingForSectionAt(section: section)
    }
    
    // 最小行间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minimumLineSpacingForSectionAt(section: section)
    }
    
    // item 的尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForHeaderInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForFooterInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let moduleType = viewModel.homeRecommendList?[indexPath.section].moduleType
        if kind == UICollectionView.elementKindSectionHeader {
           
             let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: JGRecommendHeaderView.self)
            headerView.homeRecommendList = viewModel.homeRecommendList?[indexPath.section]
            // 分区头右边更多按钮点击跳转
            headerView.headerMoreBtnClick = {[weak self]() in
//                if moduleType == "guessYouLike"{
//                    let vc = LBFMHomeGuessYouLikeMoreController()
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }else if moduleType == "paidCategory" {
//                    let vc = LBFMHomeVIPController(isRecommendPush:true)
//                    vc.title = "精品"
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }else if moduleType == "live"{
//                    let vc = LBFMHomeLiveController()
//                    vc.title = "直播"
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }else {
//                    guard let categoryId = self?.viewModel.homeRecommendList?[indexPath.section].target?.categoryId else {return}
//                    if categoryId != 0 {
//                        let vc = LBFMClassifySubMenuController(categoryId:categoryId,isVipPush:false)
//                        vc.title = self?.viewModel.homeRecommendList?[indexPath.section].title
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
            }
            return headerView
        }else {
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: JGRecommendFooterView.self)
            return footerView
        }
    }
}
