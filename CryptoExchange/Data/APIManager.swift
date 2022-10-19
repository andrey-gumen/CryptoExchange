import Alamofire

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
    }
    
    private var authorizationHeader: HTTPHeaders {
        ["X-CoinAPI-Key": "BCC8F92D-F5D5-417C-B9F2-921893AFE609"]
    }

    // MARK: requests
    func getAssets(completion: @escaping ((Error?, [CurrencyDescriptor]) -> Void)) {
        AF.request(
            Constants.BaseUrl.rawValue + EndPoints.Assets.rawValue,
            method: .get,
            headers: authorizationHeader
        ).responseDecodable(of: [CurrencyDescriptor].self) { data in
            switch data.result {
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
        ).responseDecodable(of: [CurrencyModel].self) { data in
            switch data.result {
            case .failure(let error): completion(error, [])
            case .success(let models): completion(nil, models)
            }
        }
    }
    
}
