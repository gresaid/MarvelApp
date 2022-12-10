//
//  CollectionViewCell.swift
//  Marvel
//
//  Created by user225687 on 11/17/22.
//

import UIKit
class CollectionViewCell: UICollectionViewCell{
    func set(heroes_set: heroesOptions){
        self.mainText.text = heroes_set.name
        self.imageView.image = heroes_set.image ?? .init()
        }
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        return imageView
    }()
    private let mainText: UILabel = {
        let mainText = UILabel()
        mainText.font = UIFont.boldSystemFont(ofSize: 30)
        mainText.textColor = .white
        mainText.shadowColor = .black
        mainText.shadowOffset = CGSize(width: 2, height: 2)
        return mainText
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutOption()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layoutOption(){
        addSubview(imageView)
        addSubview(mainText)
        mainText.snp.makeConstraints{ maker in
            maker.left.equalTo(self.snp.left).offset(30)
            maker.top.equalTo(self.snp.bottom).offset(-70)
        }

        imageView.snp.makeConstraints{maker in
            maker.edges.equalToSuperview()
        }
    }
    
}
