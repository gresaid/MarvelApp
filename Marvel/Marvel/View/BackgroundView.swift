//
//  Background.swift
//  Marvel
//
//  Created by user225687 on 12/4/22.
//

import UIKit

final class BackgroundView: UIImageView {
    
    private let backgroundImage = UIImage(named: "background") ?? .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 42/255, green: 39/255, blue: 43/255, alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTriangleColor(_ color: UIColor) {
        self.image = backgroundImage.withTintColor(color)
    }
}
