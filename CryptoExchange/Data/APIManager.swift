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
        case Icons = "/assets/icons/small"
    }
    
    private var authorizationHeader: HTTPHeaders {
        ["X-CoinAPI-Key": "44116C84-40DE-4360-A06E-612DAC3C0205"]
        //["X-CoinAPI-Key": "0481018D-3570-41A5-8C69-7F5AC9C64342"]
        //["X-CoinAPI-Key": "BCC8F92D-F5D5-417C-B9F2-921893AFE609"]
    }

    // MARK: requests
    func getAssets(completion: @escaping ((Result<[CurrencyDescriptor], AFError>) -> Void)) {
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Assets.rawValue,
            method: .get,
            headers: authorizationHeader
        ).responseDecodable(of: [CurrencyDescriptor].self) { response in
            completion(response.result)
        }
    }
    
    func getCurrencyDetails(ids: String,  completion: @escaping ((Result<[CurrencyModel], AFError>) -> Void)) {
        let parameters: Parameters = ["filter_asset_id": ids]

        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Assets.rawValue,
            method: .get,
            parameters: parameters,
            headers: authorizationHeader
        ).responseDecodable(of: [CurrencyModel].self) { response in
            completion(response.result)
        }
    }
       
    func getCurrencyIcon(completion: @escaping ((Result<[CurrencyIcon], AFError>) -> Void)) {
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Icons.rawValue,
            method: .get,
            headers: authorizationHeader
        ).responseDecodable(of: [CurrencyIcon].self) { response in
            completion(response.result)
        }
    }
    
    func downloadImage(url: String,  completion: @escaping ((Result<UIImage?, Error>) -> Void)) {
        AF.request(
            url,
            method: .get,
            headers: authorizationHeader
        ).response { response in
            switch response.result {
            case .failure(let error): completion(.failure(error))
            case .success(let data): completion(.success(UIImage(data: data!, scale: 1)))
            }
        }
    }
    
}
