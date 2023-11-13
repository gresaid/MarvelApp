import UIKit
import SwiftyJSON
import Alamofire
import CryptoKit

public let baseUrl = "https://gateway.marvel.com/v1/public/characters"


struct HeroModel{
    let name: String
    let description: String
    let imageLink: String
    let heroId: Int
       init(id: Int, name: String, imagelink: String, description: String) {
           self.heroId = id
           self.name = name
           self.description = description
           if imagelink.hasSuffix("jpg") {
               self.imageLink = imagelink
           } else {
               self.imageLink = imagelink + "/portrait_uncanny.jpg"
           }
       }
   }

   func getHero(id: Int = -1, offset: Int = 0, _ completion: @escaping ([HeroModel]) -> Void) {
       AF.request(
           baseUrl + (id == -1 ? "" : "/\(id)"),
           parameters: requestParams(offset: offset)
       ).responseDecodable(of: HeroPayload.self) { response in
           switch response.result {
           case .success(let heroPayload):
               let heroDecodable = heroPayload.data?.results
               var heroModelArray: [HeroModel] = []
               for hero in heroDecodable! {
                   let newModel = HeroModel(id: hero?.id ?? -1, name: hero?.name ?? "",
                                                 imagelink: hero?.thumbnail?.imageUrlString ?? "",
                                                 description: hero?.description ?? "")
                   heroModelArray.append(newModel)
               }
               completion(heroModelArray)
           case .failure(let failure):
               NSLog(failure.localizedDescription)
           }
       }
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
