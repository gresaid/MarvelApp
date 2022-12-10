//
//  CollectionViewCell.swift
//  Marvel
//
//  Created by user225687 on 11/17/22.
//
import Kingfisher
import UIKit
class CollectionViewCell: UICollectionViewCell{
    func set(heroData: HeroModel, and tag: Int){
        imageView.image = .init()
              imageView.layoutIfNeeded()
              let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                           |> RoundCornerImageProcessor(cornerRadius: 20)
              imageView.kf.setImage(
                  with: heroData.imageLink ?? URL.init(string: ""),
                  options: [
                      .processor(processor)
                  ]
              ) {
                  switch $0 {
                  case .success(let value):
                      NSLog("Task done for: \(value.source.url?.absoluteString ?? "")")
                  case .failure(let error):
                      NSLog("Job failed: \(error.localizedDescription)")
                  }
              }
              imageView.tag = tag
        self.mainText.text = heroData.name
   
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
