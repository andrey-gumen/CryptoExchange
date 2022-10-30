import UIKit

protocol CurrencyListView: AnyObject {
    var isRequestSent: Bool { get set }
    func repaintList(models: [CurrencyDescriptor])
}
