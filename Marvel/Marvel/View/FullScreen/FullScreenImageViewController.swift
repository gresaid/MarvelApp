import UIKit
import SnapKit
import Kingfisher
class FullScreenImageViewController: UIViewController {
    
    private let textOffset = 30
    
    private let wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let heroNameTextLabel: UILabel = {
        let heroNameTextLabel = UILabel()
        heroNameTextLabel.font = UIFont.boldSystemFont(ofSize: 17)
        heroNameTextLabel.textColor = .white
        heroNameTextLabel.shadowColor = .black
        heroNameTextLabel.shadowOffset = CGSize(width: 1, height: 1)
        return heroNameTextLabel
    }()
    
    private let heroDescriptionTextLabel: UILabel = {
        let heroDescriptionTextLabel = UILabel()
        heroDescriptionTextLabel.font = UIFont.boldSystemFont(ofSize: 15)
        heroDescriptionTextLabel.textColor = .white
        heroDescriptionTextLabel.lineBreakMode = .byWordWrapping
        heroDescriptionTextLabel.numberOfLines = 0
        heroDescriptionTextLabel.shadowColor = .black
        heroDescriptionTextLabel.shadowOffset = CGSize(width: 1, height: 1)
        return heroDescriptionTextLabel
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(heroData: HeroModel?, tag: Int) {
        heroImageView.image = .init()
        wrapperView.tag = tag
        guard let data = heroData else { return }
        getHero(id: data.heroId) { [weak self] result in
            switch result {
            case .success(let heroModel):
                self?.heroImageView.kf.setImage(with: URL(string: heroModel.imageLink) ?? URL(string: "http://127.0.0.1"))
                self?.heroNameTextLabel.text = heroModel.name
                self?.heroDescriptionTextLabel.text = heroModel.heroDescription
            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        }
    }
        



    
        override func viewDidLoad() {
            super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        
        view.addSubview(wrapperView)
        wrapperView.addSubview(heroImageView)
        wrapperView.addSubview(heroDescriptionTextLabel)
        wrapperView.addSubview(heroNameTextLabel)
 
        wrapperView.snp.makeConstraints { $0.edges.equalTo(view)
        }
        heroImageView.snp.makeConstraints { $0.edges.equalTo(wrapperView)
        }
        
        heroDescriptionTextLabel.snp.makeConstraints {
            $0.left.equalTo(wrapperView.snp.left).offset(textOffset)
            $0.right.equalTo(wrapperView.snp.right).offset(-textOffset)
            $0.bottom.equalTo(wrapperView.snp.bottom).offset(-textOffset)
        }
        heroNameTextLabel.snp.makeConstraints {
            $0.left.equalTo(wrapperView.snp.left).offset(textOffset)
            $0.right.equalTo(wrapperView.snp.right)
            $0.bottom.equalTo(heroDescriptionTextLabel.snp.top).offset(-10)
        }
    }
}
