//
//  heroesOptions.swift
//  Marvel
//
//  Created by user225687 on 11/17/22.
//
import UIKit

struct HeroModel{
    let name: String
    let imageLink: URL?
    let color: UIColor
    
    init(name:String,  imageLink: URL?, color: UIColor){
        self.name = name
        self.imageLink = imageLink
        self.color = color

    }
    
}
