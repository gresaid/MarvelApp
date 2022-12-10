import UIKit
import SnapKit

final class ViewController: UIViewController {

    private let heroData = HeroData()
    private let backgroundView = BackgroundView(frame: .zero)
    private var currentSelectedItemIndex = 0
    
    private var fullScreenTransitionManager: FullScreenTransitionManager?
    
    private let fullScreenImageViewController = FullScreenImageViewController()
    
    private let marvelLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "marvel_logo")
        return logo
    }()

    private let headerText: UILabel = {
        let headerText = UILabel()
        headerText.text = "Choose your hero"
        headerText.font = UIFont.boldSystemFont(ofSize: 35)
        headerText.textColor = .white
        headerText.textAlignment = .center
        headerText.translatesAutoresizingMaskIntoConstraints = false
        return headerText
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.itemSize = Constants.collectionViewLayoutItemSize
        layout.minimumLineSpacing = Constants.itemSpasing
        layout.scrollDirection = .horizontal
        layout.sectionInset = Constants.collectionViewLayoutInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        view.addSubview(marvelLogo)
        view.addSubview(headerText)
        registerCollectionViewCells()
        view.addSubview(collectionView)
        backgroundView.setTriangleColor(heroData.get(0).color)
        setLayout()
    }

    private func setLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        marvelLogo.snp.makeConstraints { $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view).offset(70.0)
            $0.size.equalTo(CGSize(width: 140, height: 30))
        }
        headerText.snp.makeConstraints { $0.top.equalTo(marvelLogo.snp.bottom).offset(20)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
        }
        collectionView.snp.makeConstraints { $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.top.equalTo(headerText.snp.bottom).offset(10)
            $0.bottom.equalTo(view.snp.bottom).offset(-30)
        }
    }

    private func registerCollectionViewCells() {
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroData.count()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionViewCell.self),
            for: indexPath) as? CollectionViewCell else {
            return .init()
        }
        let tag = indexPath.item + 1
        cell.set(heroData: heroData.get(indexPath.item), and: tag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = indexPath.row + 1
        let heroData = heroData.get(indexPath.item)
        let fullScreenTransitionManager = FullScreenTransitionManager(anchorViewTag: tag)
        fullScreenImageViewController.setup(heroData: heroData, tag: tag)
        fullScreenImageViewController.modalPresentationStyle = .custom
        fullScreenImageViewController.transitioningDelegate = fullScreenTransitionManager
        present(fullScreenImageViewController, animated: true)
        self.fullScreenTransitionManager = fullScreenTransitionManager
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            currentSelectedItemIndex = indexPath.row
            backgroundView.setTriangleColor(heroData.get(indexPath.row).color)
        }
    }
}
