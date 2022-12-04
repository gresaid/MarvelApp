//
//  CollectionViewCell.swift
//  Marvel
//
//  Created by user225687 on 11/17/22.
//

import UIKit
class CollectionViewCell: UICollectionViewCell{
    func set(heroesSet: heroesOptions){
        self.mainText.text = heroesSet.name
        self.imageView.image = heroesSet.image ?? .init()
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
        mainText.snp.makeConstraints{ $0.left.equalTo(self.snp.left).offset(30)
            $0.top.equalTo(self.snp.bottom).offset(-70)
        }

        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}
