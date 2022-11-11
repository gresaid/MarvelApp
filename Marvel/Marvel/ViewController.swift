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
        initialize()
        registerCollectionViewCells()
        applyConstraints()
        
    }
    private func initialize(){
        view.backgroundColor = UIColor(red: 42/255, green: 39/255, blue: 43/255, alpha: 1.0)
        
            let logo = UIImageView()
            logo.image = UIImage(named: "marvel_logo")
            
        
        let headerText = UILabel()
        headerText.text = "⛰ Choose your hero"
        headerText.font = UIFont.boldSystemFont(ofSize: 35)
        headerText.textColor = .white
        view.addSubview(headerText)
        view.addSubview(logo)
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
      let cellWidth = (3 / 4) * UIScreen.main.bounds.width
    let cellHeight = (2/4) * UIScreen.main.bounds.height
      let sectionSpacing = (1 / 8) * UIScreen.main.bounds.width
      let cellSpacing = (1 / 16) * UIScreen.main.bounds.width
      
      let colors: [UIColor] = [.red, .green, .blue, .purple, .orange, .black, .cyan]
      let cellId = "cell id"
      
      // MARK: - UI Components
      
      lazy var collectionView: UICollectionView = {
          let layout = PagingCollectionViewLayout()
          layout.scrollDirection = .horizontal
          layout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
          layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
          layout.minimumLineSpacing = cellSpacing
          
          let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collectionView.translatesAutoresizingMaskIntoConstraints = false
          collectionView.showsHorizontalScrollIndicator = false
          collectionView.backgroundColor = UIColor(red: 42/255, green: 39/255, blue: 43/255, alpha: 1.0)
          collectionView.decelerationRate = .fast
          collectionView.dataSource = self
          return collectionView
      }()
      
    
      

      
      private func registerCollectionViewCells() {
          collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
      }
      
      private func applyConstraints() {
          view.addSubview(collectionView)
          collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
          collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          collectionView.heightAnchor.constraint(equalToConstant: cellWidth).isActive = true
      }
  }

  // MARK: - CollectionView Data Source
  extension ViewController: UICollectionViewDataSource {
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return colors.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
          let color = colors[indexPath.item]
          cell.backgroundColor = color
          return cell
      }


}

