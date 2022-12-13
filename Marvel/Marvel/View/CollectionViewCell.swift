//
//  CollectionViewCell.swift
//  Marvel
//
//  Created by user225687 on 11/17/22.
//
import Kingfisher
import UIKit
class CollectionViewCell: UICollectionViewCell{
    private let circle: UIActivityIndicatorView = {
           let circle = UIActivityIndicatorView(style: .large)
           circle.color = .white
           return circle
       }()
    func set(heroData: HeroModel?, and tag: Int){
        imageView.image = .init()
        imageView.layoutIfNeeded()
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                           |> RoundCornerImageProcessor(cornerRadius: 20)
        guard let data = heroData else { circle.startAnimating(); return }
                let resource = ImageResource(downloadURL: URL(string: data.imageLink) ?? URL(string: "http://127.0.0.1")!, cacheKey: "\(data.heroId)")
              imageView.kf.setImage(
                with: resource,
                           placeholder: UIImage(named: ""),
                  options: [
                    .processor(processor),
                    .cacheOriginalImage
                  ]
              ) { [weak self] result in
                  self?.circle.stopAnimating()
                  switch result {
                  case .success(let value):
                      NSLog("Task done for: \(value.source.url?.absoluteString ?? "")")
                  case .failure(let error):
                      NSLog("Job failed: \(error.localizedDescription)")
                  }
              }
              imageView.tag = tag
        self.mainText.text = data.name
   
        }
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .clear
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
        imageView.kf.indicatorType = .activity
        layoutOption()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layoutOption(){
        addSubview(circle)
        circle.snp.makeConstraints {
                   $0.centerY.equalToSuperview()
                   $0.centerX.equalTo(self.snp.left)
               }
        addSubview(imageView)
        addSubview(mainText)
        mainText.snp.makeConstraints{
            $0.left.equalTo(self.snp.left).offset(30)
            $0.top.equalTo(self.snp.bottom).offset(-70)
            $0.right.equalTo(self.snp.right).offset(-10)
        }

        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}
