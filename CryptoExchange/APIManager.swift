import Alamofire

final class APIManager {
    
    // MARK: Singleton iplementation
    
    static let shared = APIManager()
    private init () {}
    
    // MARK: server constantce
    
    private enum Constants : String {
        case BaseUrl = "https://rest.coinapi.io/v1"
    }
    
    private enum EndPoints : String {
        case Exchanges = "/exchanges"
        case Assets = "/assets"
    }
    
    private var authorizationHeader: HTTPHeaders {
        ["X-CoinAPI-Key": "0481018D-3570-41A5-8C69-7F5AC9C64342"]
    }

    // MARK: requests
    func getAssets(completion: @escaping (([CryptoCurrencyModel]) -> Void)) {
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Assets.rawValue,
            method: .get,
            headers: authorizationHeader
        ).responseDecodable(of: [CryptoCurrencyModel].self) { data in
            switch data.result {
            case .failure(let error): print(error)
            case .success(let models): completion(models)
            }
        }
    }
       
    func getCurrencyDetails(ids: String,  completion: @escaping (([CryptoCurrencyModel]) -> Void)) {
        let parameters: Parameters = ["filter_asset_id": ids]
        
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Assets.rawValue,
            method: .get,
            parameters: parameters,
            headers: authorizationHeader
        ).responseDecodable(of: [CryptoCurrencyModel].self) { data in
            switch data.result {
            case .failure(let error): print(error)
            case .success(let models): completion(models)
            }
        }
    }
    
}
