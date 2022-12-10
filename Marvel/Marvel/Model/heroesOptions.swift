//
//  heroesOptions.swift
//  Marvel
//
//  Created by user225687 on 11/17/22.
//
import UIKit

struct heroesOptions{
    let name: String
    let image: UIImage?
    let color: UIColor
    
    init(name:String,  image: UIImage?, color: UIColor){
        self.name = name
        self.image = image
        self.color = color

    }
    
}
