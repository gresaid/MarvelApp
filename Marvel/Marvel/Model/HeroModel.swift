import UIKit
import SwiftyJSON
import Alamofire
import CryptoKit
import RealmSwift

public let baseUrl = "https://gateway.marvel.com/v1/public/characters"


final class HeroModel: Object{
   @Persisted var name: String
    @Persisted var heroDescription: String
    @Persisted var  imageLink: String
    @Persisted(primaryKey: true) var  heroId: Int
       convenience init(id: Int, name: String, imagelink: String, description: String) {
           self.init()
           self.heroId = id
           self.name = name
           self.heroDescription = description
           if imagelink.hasSuffix("jpg") {
               self.imageLink = imagelink
           } else {
               self.imageLink = imagelink + "/portrait_uncanny.jpg"
           }
       }
   }
func getHeroes(offset: Int = 0, _ completion: @escaping (Result<[HeroModel], Error>) -> Void) {
    AF.request(
       
        baseUrl,
        parameters: requestParams(offset: offset)
    ).responseDecodable(of: HeroPayload.self) { response in
        switch response.result {
        case .success(let heroPayload):
            let heroDecodable = heroPayload.data?.results
            var heroModelArray: [HeroModel] = []
            heroDecodable?.forEach { heroModelArray.append(createHeroFromDecodable(hero: $0)) }
            completion(.success(heroModelArray))
        case .failure(let failure):
            NSLog(failure.localizedDescription)
            completion(.failure(failure))
        }
    }
}
func getHero(id: Int, _ completion: @escaping (Result<HeroModel, Error>) -> Void) {
    AF.request(
        baseUrl + "/\(id)",
        parameters: requestParams()
    ).responseDecodable(of: HeroPayload.self) { response in
        switch response.result {
        case .success(let heroesPayload):
            let heroDecodable = heroesPayload.data?.results
            var heroModelArray: [HeroModel] = []
            heroDecodable?.forEach { heroModelArray.append(createHeroFromDecodable(hero: $0)) }
            completion(.success(heroModelArray.first ?? .init()))
        case .failure(let failure):
            NSLog(failure.localizedDescription)
            completion(.failure(failure))
        }
    }
}
func createHeroFromDecodable(hero: HeroDecodable?) -> HeroModel {
    return HeroModel(id: hero?.id ?? -1, name: hero?.name ?? "",
                          imagelink: hero?.thumbnail?.imageUrlString ?? "",
                          description: hero?.description ?? "")
}
   struct HeroPayload: Decodable {
       let data: HeroListDecodable?
   }

   struct HeroListDecodable: Decodable {
       let count: Int?
       let results: [HeroDecodable?]?
   }

   struct HeroDecodable: Decodable {
       let name: String?
       let id: Int?
       let thumbnail: Thumbnail?
       let description: String?
   }

   struct Thumbnail: Decodable {
       let imageUrlString: String?
       let imageExtension: String?
       enum CodingKeys: String, CodingKey {
           case imageUrlString = "path"
           case imageExtension = "extension"
       }
   }

   func requestParams(offset: Int = 0) -> [String: String] {
       let privateKey = "09123f0b1bb7afb5a461e19a8187c34eab6af828"
       let apikey = "99ef6fd77d3f2c6ce49ff7d413355db1"
       let timeStamp = NSDate().timeIntervalSince1970
       let hash = getHash(timeStamp: timeStamp, apikey: apikey, privateKey: privateKey)
       return ["apikey": apikey, "ts": "\(timeStamp)", "hash": hash, "offset": "\(offset)"]
   }

   private func getHash(timeStamp: Double, apikey: String, privateKey: String) -> String {
       let dirtyMd5 = Insecure.MD5.hash(data: "\(timeStamp)\(privateKey)\(apikey)".data(using: .utf8)!)
       return dirtyMd5.map { String(format: "%02hhx", $0) }.joined()
   }
