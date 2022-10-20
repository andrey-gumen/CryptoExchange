import Alamofire
import UIKit

final class APIManager {
    
    // MARK: Singleton iplementation
    
    static let shared = APIManager()
    private init () {}
    
    // MARK: server constants
    
    private enum Constants : String {
        case BaseUrl = "https://rest.coinapi.io/v1"
    }
    
    private enum EndPoints : String {
        case Exchanges = "/exchanges"
        case Assets = "/assets"
        case Icons = "/assets/icons"
    }
    
    private var authorizationHeader: HTTPHeaders {
        ["X-CoinAPI-Key": "44116C84-40DE-4360-A06E-612DAC3C0205"]
        //["X-CoinAPI-Key": "0481018D-3570-41A5-8C69-7F5AC9C64342"]
        //["X-CoinAPI-Key": "BCC8F92D-F5D5-417C-B9F2-921893AFE609"]
    }

    // MARK: requests
    func getAssets(completion: @escaping ((Error?, [CurrencyDescriptor]) -> Void)) {
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Assets.rawValue,
            method: .get,
            headers: authorizationHeader
        ).responseDecodable(of: [CurrencyDescriptor].self) { response in
            switch response.result {
            case .failure(let error): completion(error, [])
            case .success(let models): completion(nil, models)
            }
        }
    }
       
    func getCurrencyDetails(ids: String,  completion: @escaping ((Error?, [CurrencyModel]) -> Void)) {
        let parameters: Parameters = ["filter_asset_id": ids]
        
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Assets.rawValue,
            method: .get,
            parameters: parameters,
            headers: authorizationHeader
        ).responseDecodable(of: [CurrencyModel].self) { response in
            switch response.result {
            case .failure(let error): completion(error, [])
            case .success(let models): completion(nil, models)
            }
        }
    }
    
    func getCurrencyIcon(completion: @escaping ((Error?, [CurrencyIcon]) -> Void)) {
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Icons.rawValue,
            method: .get,
            headers: authorizationHeader
        ).responseDecodable(of: [CurrencyIcon].self) { response in
            switch response.result {
            case .failure(let error): completion(error, [])
            case .success(let models): completion(nil, models)
            }
        }
    }
    
    func downloadImage(url: String,  completion: @escaping ((Error?, UIImage?) -> Void)) {
        AF.request(
            url,
            method: .get,
            headers: authorizationHeader
        ).response { response in
            switch response.result {
            case .failure(let error): completion(error, nil)
            case .success(let data): completion(nil, UIImage(data: data!, scale: 1))
            }
        }
    }
    
}
