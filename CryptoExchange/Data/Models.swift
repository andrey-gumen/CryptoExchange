// MARK: currency descriptor
struct CurrencyDescriptor: Codable {
    let id: String
    let name: String
    let priceInUsd: Double?

    enum CodingKeys: String, CodingKey {
        case id = "asset_id"
        case name
        case priceInUsd = "price_usd"
    }
}

extension CurrencyDescriptor: CustomStringConvertible {
    var description: String {
        let price = priceInUsd != nil ? String(format: "$%.2f", priceInUsd!) : "-"
        return "\nName: \(name) (\(id)) / Price: \(price): \n-------"
    }
}

// MARK: currency icon
struct CurrencyIcon: Codable {
    let id: String
    let iconUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "asset_id"
        case iconUrl = "url"
    }
}

// MARk: detailed currency model
struct CurrencyModel: Codable {
    let id: String
    let name: String
    let isCryptoCurrency: Int
    let priceInUsd: Double?

    enum CodingKeys: String, CodingKey {
        case id = "asset_id"
        case name
        case isCryptoCurrency = "type_is_crypto"
        case priceInUsd = "price_usd"
    }
}
