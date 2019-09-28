//
//  JGOneKeyListenCell.swift
//  JG_XMLY
//
//  Created by 郭军 on 2019/4/23.
//  Copyright © 2019 guojun. All rights reserved.
//

import UIKit


class XMOneKeyListenCell: JGBaseCollectionCell {
    
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
 
    override func configUI() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(70)
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.imageView.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
    }
    
    var oneKeyListen:JGOneKeyListenModel? {
        didSet {
            guard let model = oneKeyListen else { return }
            if (model.coverRound != nil) {
                self.imageView.kf.setImage(with: URL(string: model.coverRound!))
            }
            self.titleLabel.text = model.channelName
        }
    }
}



class JGOneKeyListenCell: JGBaseCollectionCell {
    
    private var oneKeyListen:[JGOneKeyListenModel]?
    private lazy var changeBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("换一批", for: UIControl.State.normal)
        button.setTitleColor(JGButtonColor, for: UIControl.State.normal)
        button.backgroundColor = UIColor.init(red: 254/255.0, green: 232/255.0, blue: 227/255.0, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(updataBtnClick(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    // - 懒加载九宫格分类按钮
    private lazy var gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (kScreenWidth - 45) / 3, height:120)
        let collectionView = UICollectionView.init(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(cellType: XMOneKeyListenCell.self)
        return collectionView
    }()
    
    
    override func configUI() {
        self.addSubview(self.gridView)
        self.gridView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        self.addSubview(self.changeBtn)
        self.changeBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
    }
    
    // 更换一批按钮刷新cell
    @objc func updataBtnClick(button:UIButton){
        
    }
    
    var oneKeyListenList:[JGOneKeyListenModel]? {
        didSet {
            guard let model = oneKeyListenList else { return }
            self.oneKeyListen = model
            self.gridView.reloadData()
        }
    }
    
    
}


extension JGOneKeyListenCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.oneKeyListen?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: XMOneKeyListenCell.self)
        cell.oneKeyListen = self.oneKeyListen?[indexPath.row]
        return cell
    }
}

