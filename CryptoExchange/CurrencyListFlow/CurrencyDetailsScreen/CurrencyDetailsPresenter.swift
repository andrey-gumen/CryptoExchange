import UIKit

protocol CurrencyDetailsPresenter {
    var currencyModel: CurrencyModel? { get }
    var currencyIcon: UIImage? { get }
    
    func requestCurrencyDetails()
}

final class DefaultCurrencyDetailsPresenter: CurrencyDetailsPresenter {
    
    private var currencyId: String
    private unowned let view: CurrencyDetailsView
    
    init(id: String, view: CurrencyDetailsView) {
        self.view = view
        currencyId = id
    }
    
    var currencyModel: CurrencyModel? = nil
    var currencyIcon: UIImage? = nil
    
    func requestCurrencyDetails() {
        view.setActivityIndicator(activated: true)
        
        let group = DispatchGroup()
        group.enter()
        requestDetails(id: currencyId) { model in
            self.currencyModel = model
            group.leave()
        }
        
        group.enter()
        requestIcon(id: currencyId) { image in
            self.currencyIcon = image
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.view.updateView()
            self.view.setActivityIndicator(activated: false)
        }
    }
    
    // MARK: internal requests
    
    private func requestDetails(id: String, completion: @escaping (CurrencyModel?) -> ()) {
        APIManager.shared.getCurrencyDetails(ids: id) { result in
            var model: CurrencyModel? = nil
            switch result {
            case .success(let models):
                model = models[0]
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            completion(model)
        }
    }
    
    private func requestIcon(id: String, completion: @escaping (UIImage?) -> ()) {
        APIManager.shared.getCurrencyIcon { result in
            let group = DispatchGroup()
            var image: UIImage? = nil
            
            switch result {
            case .success(let icons):
                if let icon = icons.first(where: {$0.id == id}) {
                    group.enter()
                    APIManager.shared.downloadImage(url: icon.iconUrl) { result in
                        switch result {
                        case .success(let downloadedImage):
                            image = downloadedImage
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        
                        group.leave()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            group.notify(queue: DispatchQueue.global()) {
                completion(image)
            }
        }
    }
    
}
