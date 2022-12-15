import UIKit
import SnapKit
import Alamofire
import Kingfisher
import RealmSwift
import Realm
extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector])
        else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

final class ViewController: UIViewController {
    private var offset: Int = 0 {
        willSet { NSLog("\nNew offset = \(newValue)\n") }
    }
    private var isFetchingData = false
    private let backgroundView = BackgroundView(frame: .zero)
    private var currentSelectedItemIndex = 0
    private var fullScreenTransitionManager: FullScreenTransitionManager?
    
    private let fullScreenImageViewController = FullScreenImageViewController()
    
    
    private lazy var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading data")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        mainScrollView.refreshControl = refreshControl
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
        return mainScrollView
    }()
    
    private let contentView = UIView()
    
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    let realm = try? Realm()
    
    private lazy var heroArray: [HeroModel?] = [] {
        willSet {
            try? realm?.write { realm?.add(newValue.compactMap { $0 }, update: .modified) }
        }
        didSet {
            collectionView.reloadData()
        }
    }


    private lazy var getMoreHeroes: () -> Void = {
            let workItem = DispatchWorkItem {
                getHeroes(offset: self.offset) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let heroModelArray):
                        if  self.heroArray.count > 0 {
                            self.heroArray.remove(at: self.heroArray.count - 1)
                        }
                        self.heroArray.append(contentsOf: heroModelArray)
                        self.heroArray.append(nil)
                        self.offset += heroModelArray.count
                    case .failure(let error):
                        self.heroArray = {
                            guard let results = self.realm?.objects(HeroModel.self) else { return [] }
                            return Array(results)
                        }()
                    }
                }
            }
            workItem.notify(queue: .main) { [weak self] in
                self?.isFetchingData = false
            }
            if !self.isFetchingData {
                self.isFetchingData = true
                DispatchQueue.main.async(execute: workItem)
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        getMoreHeroes()
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(backgroundView)
        contentView.addSubview(marvelLogo)
        contentView.addSubview(headerText)
        registerCollectionViewCells()
        view.addSubview(collectionView)
        backgroundView.setTriangleColor(.white)
        mainScrollView.contentInsetAdjustmentBehavior = .never
        mainScrollView.alwaysBounceHorizontal = false
        mainScrollView.alwaysBounceVertical = true
        setLayout()
    }
    @objc func refresh() {
            offset = 0
            heroArray.removeAll(keepingCapacity: true)
            DispatchQueue.global().async { [weak self] in
                self?.getMoreHeroes()
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.mainScrollView.refreshControl?.endRefreshing()
                }
            }
        }
    private func setLayout() {
        mainScrollView.snp.makeConstraints { $0.edges.equalTo(view.snp.edges)
              }
        contentView.snp.makeConstraints{
        $0.edges.equalToSuperview()
                  $0.height.equalToSuperview()
                  $0.width.equalToSuperview()
              }
              backgroundView.snp.makeConstraints { $0.edges.equalTo(contentView.snp.edges)
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
                return heroArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionViewCell.self),
            for: indexPath) as? CollectionViewCell else {
            return .init()
        }
        let tag = indexPath.item + 1
        cell.set(heroData: heroArray[indexPath.item], and: tag)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = indexPath.row + 1
        let heroData = heroArray[indexPath.item]
        let fullScreenTransitionManager = FullScreenTransitionManager(anchorViewTag: tag)
        fullScreenImageViewController.setup(heroData: heroData, tag: tag)
        fullScreenImageViewController.modalPresentationStyle = .custom
        fullScreenImageViewController.transitioningDelegate = fullScreenTransitionManager
        present(fullScreenImageViewController, animated: true)
        self.fullScreenTransitionManager = fullScreenTransitionManager
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == heroArray.count - 1 {
            getMoreHeroes()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            currentSelectedItemIndex = indexPath.row
            let cache = ImageCache.default
            cache.retrieveImage(forKey: "\(heroArray[indexPath.row]?.heroId ?? 0)") { result in
                            switch result {
                            case .success(let value):
                                DispatchQueue.global(qos: .background).async {
                                    let color = value.image?.averageColor ?? .clear
                                    DispatchQueue.main.async {
                                        self.backgroundView.setTriangleColor(color)
                                    }
                                }
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
        }
    }
}
