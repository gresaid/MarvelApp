//
//  ViewController.swift
//  Marvel
//
//  Created by user225687 on 10/27/22.
//
import SnapKit
import UIKit


class ViewController: UIViewController {
    let background = BackgroundView(frame: .zero)
    private final let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    private final let marvelLogo : UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named:"marvel_logo")
        return logo
    }()
    private final let headerText : UILabel = {
        let headerText = UILabel()
        headerText.text = "⛰ Choose your hero"
        headerText.font = UIFont.boldSystemFont(ofSize: 35)
        headerText.textColor = .white
        return headerText
    }()
  override func viewDidLoad() {
        super.viewDidLoad()
      
      view.addSubview(background)
      view.addSubview(marvelLogo)
      view.addSubview(headerText)
      registerCollectionViewCells()
      
      view.addSubview(collectionView)
      setLayout()
    }
    private func setLayout(){
        
        background.snp.makeConstraints {
            $0.edges.equalTo(view.snp.edges)
        }
        collectionView.snp.makeConstraints {
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.top.equalTo(headerText.snp.bottom).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        marvelLogo.snp.makeConstraints{
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view).offset(70.0)
            $0.size.equalTo(CGSize(width: 146, height: 43))
        }
        headerText.snp.makeConstraints{
            $0.left.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(150)
        }
        
        
    }
    
    
      
    
     
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
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CollectionViewCell else {
            return .init()
            // let h = heroes[indexPath.item]
        }
        cell.set(heroesSet: heroes[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            background.setTriangleColor(heroes[indexPath.row].color)
        }
        
    }
}
