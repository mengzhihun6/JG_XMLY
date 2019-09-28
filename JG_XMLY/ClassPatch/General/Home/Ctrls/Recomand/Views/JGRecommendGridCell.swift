//
//  JGRecommendGridCell.swift
//  JG_XMLY
//
//  Created by 郭军 on 2019/4/23.
//  Copyright © 2019 guojun. All rights reserved.
//

import UIKit

class JGRecommendGridCell: JGBaseCollectionCell {
 
    private lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    
    override func configUI() {
        
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalTo(self.imageView.snp.bottom).offset(5)
        }
    }
    
    
    var square:JGSquareModel? {
        didSet{
            guard let model = square else { return }
            self.imageView.kf.setImage(with: URL(string: model.coverPath!))
            self.titleLabel.text = model.title
        }
    }
}
