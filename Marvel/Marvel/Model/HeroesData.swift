//
//  HeroesData.swift
//  Marvel
//
//  Created by user225687 on 12/4/22.
//

import UIKit
struct HeroData{
    let heroData = [HeroModel(name: "Deadpool", imageLink:URL(string: "https://github.com/gresaid/MarvelApp/blob/develop/Marvel/Marvel/Assets.xcassets/deadpool.imageset/deadpool.png?raw=true"), color: .red),
                    HeroModel(name: "Iron Man",  imageLink:URL(string: "https://github.com/gresaid/MarvelApp/blob/develop/Marvel/Marvel/Assets.xcassets/Iron_man.imageset/Iron_man.png?raw=true"), color: .yellow),
                    HeroModel(name: "Spider man", imageLink:URL(string: "https://github.com/gresaid/MarvelApp/blob/develop/Marvel/Marvel/Assets.xcassets/spider_man.imageset/spider_man.png?raw=true"), color: .blue),
                    HeroModel(name: "Thanos", imageLink: URL(string: "https://github.com/gresaid/MarvelApp/blob/develop/Marvel/Marvel/Assets.xcassets/Thanos.imageset/Thanos.png?raw=true"), color: .purple)]
    func get(_ index: Int) -> HeroModel {
        return heroData[index]
    }
    func count() -> Int {
        return heroData.count
    }
}
