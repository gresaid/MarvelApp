//
//  ViewController.swift
//  Marvel
//
//  Created by user225687 on 10/27/22.
//
import SnapKit
import UIKit


class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
  override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCells()
        
        view.addSubview(collectionView)
        initialize()
    }
    private func initialize(){
        view.backgroundColor = UIColor(red: 42/255, green: 39/255, blue: 43/255, alpha: 1.0)
        
            let logo = UIImageView()
            logo.image = UIImage(named: "marvel_logo")
            
        
        let headerText = UILabel()
        view.addSubview(headerText)
        view.addSubview(logo)
        headerText.text = "⛰ Choose your hero"
        headerText.font = UIFont.boldSystemFont(ofSize: 35)
        headerText.textColor = .white
        collectionView.snp.makeConstraints { maker in
            maker.left.equalTo(view.snp.left)
            maker.right.equalTo(view.snp.right)
            maker.top.equalTo(headerText.snp.bottom).offset(30)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        logo.snp.makeConstraints{maker in
                maker.centerX.equalTo(view.snp.centerX)
                maker.top.equalTo(view).offset(70.0)
                maker.size.equalTo(CGSize(width: 146, height: 43))
        }
        headerText.snp.makeConstraints{maker in
            maker.left.equalToSuperview().inset(20)
            maker.top.equalToSuperview().inset(150)
        }
        
        
    }
    
    
      
    
      let heroes = [heroesOptions(name: "Deadpool", colors: .red, image:UIImage(named: "deadpool")),
                    heroesOptions(name: "Iron Man", colors: .yellow, image: UIImage(named: "Iron_man")),
                    heroesOptions(name: "Spider man", colors: .blue, image: UIImage(named: "spider_man")),
                    heroesOptions(name: "Thanos", colors: .purple, image: UIImage(named: "Thanos"))] //, .green, .blue, .purple, .orange, .black, .cyan]
      let cellId = "cell id"
      
      // MARK: - UI Components
      
      lazy var collectionView: UICollectionView = {
          let layout = PagingCollectionViewLayout()
          layout.scrollDirection = .horizontal
          layout.sectionInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
          layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 120, height: 500)
          layout.minimumLineSpacing = 40
          
          let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionView.translatesAutoresizingMaskIntoConstraints = false
          collectionView.showsHorizontalScrollIndicator = false
          collectionView.backgroundColor = .none
          collectionView.decelerationRate = .fast
          collectionView.dataSource = self
          return collectionView
      }()
      
    
      

      
      private func registerCollectionViewCells() {
          collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
      }
      
      
  }

  // MARK: - CollectionView Data Source
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CollectionViewCell else {
            return .init()
            // let h = heroes[indexPath.item]
        }
        cell.set(heroes_set: heroes[indexPath.item])
            return cell
        }
    
    
   
}
    
